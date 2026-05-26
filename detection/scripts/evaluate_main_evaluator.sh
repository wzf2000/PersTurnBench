#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

result_file="${result_file:-outputs/personalized/qwen3_8b_test_memory_v2_none.jsonl}"
output_json="${output_json:-outputs/personalized/qwen3_8b_test_memory_v2_none_metrics.json}"

PYTHONPATH="$(pwd):${PYTHONPATH:-}" python eval/personalized.py \
  --result_file "$result_file" \
  --output_json "$output_json"
