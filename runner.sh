#!/bin/bash
set -e

# Default values
BROWSER="Chromium"
FILE="tests/"
TESTS=""
HEADLESS="True"
TAGS=""
PARALLEL="False"
PROCESSES=4
EXTRA_ARGS=""
USE_LISTENER="False"
ENABLE_SCREENSHOT="${ENABLE_SCREENSHOT:-true}"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test)
      # Support multiple --test arguments; preserve quotes for names with spaces
      TESTS+=" --test \"$2\""
      shift 2
      ;;
    --browser)
      BROWSER="$2"
      shift 2
      ;;
    --headed)
      HEADLESS="False"
      shift
      ;;
    --file)
      FILE="tests/$2"
      shift 2
      ;;
    --include)
      TAGS+=" --include $2"
      shift 2
      ;;
    --exclude)
      TAGS+=" --exclude $2"
      shift 2
      ;;
    --parallel)
      PARALLEL="True"
      shift
      ;;
    --processes)
      PROCESSES="$2"
      shift 2
      ;;
    --listener)
      USE_LISTENER="True"
      shift
      ;;
    *)
      EXTRA_ARGS+=" $1"
      shift
      ;;
  esac
done

# Print config
echo "Browser: $BROWSER"
echo "Headless: $HEADLESS"
echo "Parallel: $PARALLEL"
echo "Processes: $PROCESSES"
echo "File/Folder: $FILE"
echo "Tags: $TAGS"
echo "Tests: $TESTS"

# Construct robot options
CMD="--outputdir results --loglevel TRACE"
CMD+=" --variable BROWSER:$BROWSER"
CMD+=" --variable HEADLESS:$HEADLESS"
CMD+=" --variable ENABLE_SCREENSHOT:$ENABLE_SCREENSHOT"
if [[ -n "$TESTS" ]]; then
  CMD+="$TESTS"
fi
if [[ -n "$TAGS" ]]; then
  CMD+="$TAGS"
fi
if [[ "$USE_LISTENER" == "True" ]]; then
  CMD+=" --listener libraries/ScreenshotListener.py:$ENABLE_SCREENSHOT"
fi
CMD+=" $EXTRA_ARGS"
CMD+=" $FILE"

# Run tests
if [[ "$PARALLEL" == "True" ]]; then
  FINAL_CMD="pabot --processes $PROCESSES $CMD"
else
  FINAL_CMD="robot $CMD"
fi

echo "Running: $FINAL_CMD"
eval $FINAL_CMD