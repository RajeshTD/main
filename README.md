# RobotFramework-Browser Automation Framework

## Overview
This framework provides a robust, modular, and extensible setup for end-to-end browser automation using Robot Framework and the Browser library. It is designed for scalable test automation, supporting data-driven testing, parallel execution, and easy integration with CI/CD pipelines and Docker.

---

## Folder Structure

```
├── browser/                # Stores browser-related artifacts (e.g., traces, temp files)
│   └── traces/
│       └── temp/
├── config/                 # Configuration files for the framework
│   └── browser.robot       # Main browser and environment config
├── libraries/              # Custom Python libraries and listeners
│   ├── helper.py           # Utility functions for data and test management
│   └── ScreenshotListener.py # Listener for enhanced logging/screenshot
├── resources/              # Page objects and locators
│   ├── locators/           # Python files with element locators
│   └── pages/              # Robot files for page-level keywords
├── results/                # Test execution results (logs, reports, outputs)
│   └── browser/            # Browser-specific result artifacts
├── testdata/               # Test data in Python dicts for data-driven tests
│   └── data.py             # Centralized test data definitions
├── tests/                  # Test suites and cases
│   ├── MSIGTEST.robot      # Example test case
│   └── MSIG/               # Subfolder for grouped test suites
├── uploads/                # Sample files for upload scenarios
├── utils/                  # Shared Robot keywords and resources
│   └── common_keywords.robot # Commonly used keywords
├── .venv/                  # (Optional) Python virtual environment
├── .gitignore              # Git ignore rules
├── Dockerfile              # Docker setup for containerized execution
├── runner.sh               # Main shell script to run tests with options
├── requirements.txt        # Python and Robot Framework dependencies
└── README.md               # This documentation
```

---

## Folder & File Explanations

### browser/
- **Purpose:** Stores browser traces and temporary files generated during test runs. Useful for debugging and advanced reporting.

### config/
- **browser.robot:** Central configuration for browser settings, default URLs, and reusable keywords for launching browsers.

### libraries/
- **helper.py:** Custom Python library with utility functions for data manipulation, random data generation, Excel comparison, and more. Decorated with Robot Framework's `@keyword` for direct use in tests.
- **ScreenshotListener.py:** Implements a Robot Framework listener for enhanced logging and (optionally) screenshot capture during test execution.

### resources/
- **locators/:** Python files containing element locators for different pages or components, organized for maintainability.
- **pages/:** Robot Framework resource files implementing page object patterns. Each file contains keywords for interacting with a specific page or feature.

### results/
- **Purpose:** Stores all output artifacts from test runs, including `log.html`, `report.html`, `output.xml`, and browser logs. Subfolders may contain video recordings or trace files.

### testdata/
- **data.py:** Centralized test data in Python dictionary format. Used for data-driven and parameterized testing.

### tests/
- **MSIGTEST.robot:** Example Robot Framework test case demonstrating file upload and user flow.
- **MSIG/:** Contains grouped or end-to-end test suites (e.g., `E2E.robot` for comprehensive flows).

### uploads/
- **Purpose:** Stores files (PDFs, Excel, etc.) used for upload scenarios in tests.

### utils/
- **common_keywords.robot:** Shared keywords and reusable flows (e.g., login, user creation, navigation) for use across multiple test suites.

### .venv/
- **Purpose:** (Optional) Python virtual environment for dependency isolation.

### .gitignore
- **Purpose:** Specifies files and folders to be ignored by git (e.g., results, logs, virtual environments).

### Dockerfile
- **Purpose:** Defines a containerized environment for running tests. Uses a Robot Framework base image, installs dependencies, and sets up the entrypoint to `runner.sh`.
- **Key Steps:**
  - Copies the entire project into the container
  - Installs Python and Robot Framework dependencies
  - Sets up permissions and entrypoint

### runner.sh
- **Purpose:** Main shell script to execute tests. Supports arguments for browser type, headless/headed mode, test selection, tags, parallel execution, and more.
- **Key Options:**
  - `--test <test name>`: Run a specific test case
  - `--browser <browser>`: Choose browser (Chromium, Firefox, WebKit)
  - `--headed`: Run in headed mode (default is headless)
  - `--file <file/folder>`: Specify test file or folder
  - `--include/--exclude <tag>`: Filter tests by tags
  - `--parallel`: Enable parallel execution
  - `--processes <n>`: Number of parallel processes
  - `--listener`: Enable custom listener (e.g., for screenshots)

### requirements.txt
- **Purpose:** Lists all Python and Robot Framework dependencies required for the framework, including:
  - `robotframework`, `robotframework-browser`, `robotframework-pabot` (parallel execution), `openpyxl`, `pandas`, `xlrd`, and more.

---

## Installation & Setup

### Prerequisites
- Python 3.8+
- Node.js (for Browser library)
- Docker (optional, for containerized runs)

### Local Setup
1. **Clone the repository:**
   ```sh
   git clone <repo-url>
   cd robotframework-browser
   ```
2. **Create a virtual environment (recommended):**
   ```sh
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```
3. **Install dependencies:**
   ```sh
   pip install -r requirements.txt
   rfbrowser init  # Installs browser binaries for robotframework-browser
   ```

### Docker Setup
- Build the Docker image:
  ```sh
  docker build -t robotframework-browser .
  ```
- Run tests in Docker:
  ```sh
  docker run --rm robotframework-browser
  ```
- Pass custom arguments (e.g., run only tests with a specific tag):
  ```sh
  docker run --rm robotframework-browser --include smoke
  ```

---

## Usage

- **Run all tests:**
  ```sh
  ./runner.sh
  ```
- **Run a specific test case:**
  ```sh
  ./runner.sh --test "Test Case Name"
  ```
- **Run tests in parallel:**
  ```sh
  ./runner.sh --parallel --processes 4
  ```
- **Run with a different browser:**
  ```sh
  ./runner.sh --browser firefox
  ```
- **Run in headed mode:**
  ```sh
  ./runner.sh --headed
  ```

Test results will be available in the `results/` directory (`log.html`, `report.html`, etc.).

---

## Extending the Framework
- **Add new page objects:** Create new `.robot` files in `resources/pages/` and corresponding locators in `resources/locators/`.
- **Add new keywords:** Place reusable keywords in `utils/common_keywords.robot` or create new resource files.
- **Add test data:** Extend `testdata/data.py` with new dictionaries for data-driven scenarios.
- **Add custom Python keywords:** Implement in `libraries/helper.py` and decorate with `@keyword`.

---

## Contributing
- Clone the repository and create a feature branch.
- Add/modify tests or keywords as needed.
- Ensure all tests pass locally and in Docker(optional).
- Submit a pull request with a clear description of changes.

---

## Support
For issues, please contact the maintainers of the repo.
