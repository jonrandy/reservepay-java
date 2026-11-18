#!/usr/bin/env bash
set -euo pipefail

# Path to the wfn executable; override with the WFN_PATH env var
WFN="${WFN_PATH:-wfn}"

# Check wfn exists
if ! command -v "$WFN" >/dev/null 2>&1; then
  echo "Error: '$WFN' WebFunction CLI tool was not found in your PATH." >&2
  echo "You can specify its location using the WFN_PATH environment variable, e.g.:" >&2
  echo "  WFN_PATH=/path/to/wfn $0" >&2
  echo "If you don't have the tool, get/build it from https://github.com/webfunction-protocol/webfunction-cli" >&2
  exit 1
fi

mkdir -p src/main/java/com/reservepay/merchant src/main/java/com/reservepay/terminal src/main/java/com/reservepay/sdk

# Set the copyright year in the license to the current year
sed "s/^Copyright (c) [0-9]\{4\}/Copyright (c) $(date +%Y)/" LICENSE.txt > LICENSE.txt.tmp
mv LICENSE.txt.tmp LICENSE.txt

# Generate code for clients (each API is its own Java package, and each file must be named Client.java)
"$WFN" codegen --target java --url https://api.reservepay.com/merchants -o ./src/main/java/com/reservepay/merchant/Client.java --namespace com.reservepay.merchant
"$WFN" codegen --target java --url https://api.reservepay.com/terminals -o ./src/main/java/com/reservepay/terminal/Client.java --namespace com.reservepay.terminal
"$WFN" codegen --target java --url https://api.reservepay.com/sdk -o ./src/main/java/com/reservepay/sdk/Client.java --namespace com.reservepay.sdk

# Check the generated clients compile (needs Maven)
if command -v mvn >/dev/null 2>&1; then
  mvn -q compile
  echo "Clients generated and 'mvn compile' passed"
else
  echo "Install Maven and run 'mvn compile' to check the generated clients compile"
fi
