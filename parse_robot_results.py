import sys
import json
from xml.etree import ElementTree as ET
from datetime import datetime
import re


def _sanitize_xml_text(xml_text: str) -> str:
    """Remove characters that are not allowed in XML 1.0 and fix common issues.

    - Strips control chars not permitted by XML 1.0 spec
    - Escapes stray ampersands not part of valid entities
    """
    # Remove invalid XML 1.0 characters
    # Allowed ranges: 0x9 | 0xA | 0xD | 0x20-0xD7FF | 0xE000-0xFFFD
    invalid_xml_re = re.compile(r"[^\x09\x0A\x0D\x20-\uD7FF\uE000-\uFFFD]")
    cleaned = invalid_xml_re.sub("", xml_text)

    # Escape stray ampersands that are not starting valid XML entities
    cleaned = re.sub(r"&(?!amp;|lt;|gt;|apos;|quot;|#\d+;|#x[0-9a-fA-F]+;)", "&amp;", cleaned)
    return cleaned


def _read_and_sanitize_xml_file(xml_path: str) -> str:
    """Read an XML file as UTF-8 (replacing undecodable bytes) and sanitize it."""
    with open(xml_path, "rb") as f:
        raw = f.read()
    # Decode using UTF-8, replacing undecodable bytes to avoid parser crashes
    text = raw.decode("utf-8", errors="replace")
    return _sanitize_xml_text(text)

def parse_robot_results(xml_path):
    xml_text = _read_and_sanitize_xml_file(xml_path)
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError:
        # As a last resort, try sanitizing again in case of edge cases
        xml_text = _sanitize_xml_text(xml_text)
        root = ET.fromstring(xml_text)
    
    # Extract Robot Framework metadata
    robot_metadata = {
        "generator": root.get('generator', 'Unknown'),
        "generated": root.get('generated', 'Unknown'),
        "rpa": root.get('rpa', 'false'),
        "schemaversion": root.get('schemaversion', 'Unknown')
    }
    
    # Get statistics
    stats = root.find('statistics/total/stat')
    if stats is None:
        # Fallback if statistics section is missing
        total = passed = failed = skipped = 0
        pass_rate = 0
    else:
        total = int(stats.attrib.get('pass', 0)) + int(stats.attrib.get('fail', 0)) + int(stats.attrib.get('skip', 0))
        passed = int(stats.attrib.get('pass', 0))
        failed = int(stats.attrib.get('fail', 0))
        skipped = int(stats.attrib.get('skip', 0))
        pass_rate = round((passed / total) * 100) if total > 0 else 0

    # Calculate duration from test execution
    total_duration_seconds = 0
    start_time = None
    end_time = None
    
    # Find the main test execution
    for test in root.findall('.//test'):
        status = test.find('status')
        if status is not None:
            # Get start time from the first test
            if start_time is None and 'start' in status.attrib:
                start_time = status.attrib['start']
            
            # Get elapsed time and add to total
            if 'elapsed' in status.attrib:
                try:
                    elapsed = float(status.attrib['elapsed'])
                    total_duration_seconds += elapsed
                except (ValueError, TypeError):
                    pass
    
    # Extract browser information from messages
    browser_config = {}
    for msg in root.findall('.//msg'):
        if msg.text and 'browser' in msg.text.lower():
            # Extract browser configuration
            if 'chromium' in msg.text or 'firefox' in msg.text or 'webkit' in msg.text:
                browser_match = re.search(r'"browser":\s*"([^"]+)"', msg.text)
                if browser_match:
                    browser_config["browser_type"] = browser_match.group(1)
            
            # Extract viewport information
            viewport_match = re.search(r'"viewport":\s*{[^}]+}', msg.text)
            if viewport_match:
                viewport_text = viewport_match.group(0)
                width_match = re.search(r'"width":\s*(\d+)', viewport_text)
                height_match = re.search(r'"height":\s*(\d+)', viewport_text)
                if width_match and height_match:
                    browser_config["viewport"] = {
                        "width": int(width_match.group(1)),
                        "height": int(height_match.group(1))
                    }
            
            # Extract headless mode
            headless_match = re.search(r'"headless":\s*(true|false)', msg.text)
            if headless_match:
                browser_config["headless"] = headless_match.group(1) == 'true'
    
    # Format duration
    if total_duration_seconds > 0:
        minutes = int(total_duration_seconds // 60)
        seconds = int(total_duration_seconds % 60)
        if minutes > 0:
            duration = f"{minutes}m {seconds}s"
        else:
            duration = f"{seconds}s"
    else:
        duration = "N/A"

    # Extract failed test cases and their reasons
    failed_tests = []
    for test in root.findall('.//test'):
        status = test.find('status')
        if status is not None and status.attrib.get('status', '').upper() == 'FAIL':
            name = test.attrib.get('name', 'Unknown')
            
            # Try multiple ways to get failure reason
            reason = 'No reason provided.'
            
            # Method 1: Check status text
            if status.text and status.text.strip():
                reason = status.text.strip()
            
            # Method 2: Look for failure messages in kw elements
            if reason == 'No reason provided.':
                for kw in test.findall('.//kw'):
                    for msg in kw.findall('.//msg'):
                        if msg.text and ('FAIL' in msg.text.upper() or 'ERROR' in msg.text.upper()):
                            reason = msg.text.strip()
                            break
                    if reason != 'No reason provided.':
                        break
            
            # Method 3: Look for any msg element with failure content
            if reason == 'No reason provided.':
                for msg in test.findall('.//msg'):
                    if msg.text and len(msg.text.strip()) > 10:  # Reasonable length for error message
                        reason = msg.text.strip()
                        break
            
            # Method 4: Get the last non-empty message
            if reason == 'No reason provided.':
                messages = []
                for msg in test.findall('.//msg'):
                    if msg.text and msg.text.strip():
                        messages.append(msg.text.strip())
                if messages:
                    reason = messages[-1]  # Get the last message
            
            failed_tests.append({'name': name, 'reason': reason})
            print(f"DEBUG: Found failed test '{name}' with reason: {reason[:100]}...")  # Debug output

    print(f"DEBUG: Total failed tests found: {len(failed_tests)}")
    print(f"DEBUG: Total duration calculated: {duration}")

    return {
        "robotMetadata": robot_metadata,
        "browserInfo": browser_config,
        "total": total,
        "passed": passed,
        "failed": failed,
        "skipped": skipped,
        "passRate": pass_rate,
        "duration": duration,
        "failedTests": failed_tests
    }

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python parse_robot_results.py <input_xml> <output_json>")
        # Still exit 0 to avoid failing Jenkins post step; no output will be written
        sys.exit(0)

    xml_path = sys.argv[1]
    json_path = sys.argv[2]

    try:
        results = parse_robot_results(xml_path)
    except Exception as e:
        # Produce a minimal, valid JSON summary so downstream steps can proceed
        results = {
            "robotMetadata": {"generator": "Unknown", "generated": "Unknown", "rpa": "false", "schemaversion": "Unknown"},
            "browserInfo": {},
            "total": 0,
            "passed": 0,
            "failed": 0,
            "skipped": 0,
            "passRate": 0,
            "duration": "N/A",
            "failedTests": [],
            "__error__": f"Parsing failed: {str(e)}"
        }

    try:
        with open(json_path, "w") as f:
            json.dump(results, f)
    except Exception as write_err:
        # If we cannot write the file, print to stdout so at least logs have it
        print(json.dumps(results))
        print(f"WARN: Could not write results to {json_path}: {write_err}")
    finally:
        # Always succeed to avoid failing the Jenkins 'post' step
        sys.exit(0)
