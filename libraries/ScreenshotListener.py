# libraries/ScreenshotListener.py
import os
import time
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

class ScreenshotListener:
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, enable_screenshot=None):
        self.ROBOT_LIBRARY_LISTENER = self
        self.builtin = BuiltIn()
        self.browser_opened = False
        # Only use the argument, default to True if not provided
        if enable_screenshot is not None:
            self.enable_screenshot = str(enable_screenshot).lower() == 'true'
        else:
            self.enable_screenshot = True

    def start_test(self, name, attributes):
        logger.console(f"Starting test: {name}")

    def start_keyword(self, name, attrs):
        args = attrs.get('args', [])
        logger.console(f"Starting Keyword: {name} | Arguments: {args}")

    def end_keyword(self, name, attributes):
        logger.console(f"Keyword completed: {name}")
        keyword_type = attributes.get('type', '').lower()
        libname = attributes.get('libname', '')
        logger.console(f"Keyword: {name}, Type: {keyword_type}, Libname: {libname}, Browser Opened: {self.browser_opened}")
        # Set the flag if browser or context is launched
        if name in ['Browser.New Browser', 'Browser.Open Browser', 'Browser.New Page', 'Browser.New Context'] and attributes.get('status', '') == 'PASS':
            self.browser_opened = True
            logger.console("Browser opened flag set to True")
        # Take screenshot for library keywords only after browser/context is open, except for 'Browser.Take Screenshot'
        if self.enable_screenshot and self.browser_opened and name != 'Browser.Take Screenshot' and libname:
            logger.console(f"Attempting to take screenshot for: {name}")
            try:
                self.builtin.run_keyword('Take Screenshot', 'EMBED')
            except Exception as e:
                logger.console(f"Skipping screenshot: {e}")

    def end_test(self, name, attributes):
        logger.console(f"Ending test: {name}")