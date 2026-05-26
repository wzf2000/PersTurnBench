#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

model="${model:-Qwen/Qwen3-8B}"
vllm_base_url="${vllm_base_url:-http://localhost:8000/v1}"
vllm_api_key="${vllm_api_key:-EMPTY}"
output_jsonl="${output_jsonl:-outputs/personalized/qwen3_8b_test_memory_v2_none.jsonl}"
memory_cache_dir="${memory_cache_dir:-outputs/personalized/memory_cache}"
max_workers="${max_workers:-4}"

PYTHONPATH="$(pwd):${PYTHONPATH:-}" python trace/collect_personalized.py \
  --model "$model" \
  --vllm_base_url "$vllm_base_url" \
  --vllm_api_key "$vllm_api_key" \
  --split test \
  --memory_update_mode none \
  --memory_version v2 \
  --turn_eval_prompt_version v2 \
  --max_workers "$max_workers" \
  --memory_cache_dir "$memory_cache_dir" \
  --output_jsonl "$output_jsonl"
