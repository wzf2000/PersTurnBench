# PersTurnBench Software Release

This package contains the code subset used for the paper experiments on personalized turn-level user conversation satisfaction evaluation.
It intentionally excludes raw data, model checkpoints, training code, exploratory URS code, draft paper files, and intermediate experiment outputs.

## Directory Layout

- `detection/lib/`: data loading, user-memory construction, prompt builders, calibration/statistics utilities, and shared metrics.
- `detection/trace/`: inference pipelines for the personalized evaluator and PersTurnBench replay scoring.
- `detection/eval/`: evaluator verification metrics, baseline evaluation, and PersTurnBench aggregate metrics.
- `detection/scripts/`: runnable shell entrypoints for the main paper pipelines.
- `detection/assets/`: plotting scripts for paper figures.
- `api_config.example.json`: template for OpenAI-compatible API configuration.
- `requirements.txt`: minimal Python dependencies for running the released code.

## Data Placement

The dataset release is available on Zenodo:

<https://zenodo.org/records/20391777>

Place the data release next to the `detection/` directory:

```bash
tar -xzf persturnbench_data_release_20260526.tar.gz
mv persturnbench_data_release_20260526/data ./data
```

After this step, the release root should contain:

```text
data/
detection/
api_config.example.json
requirements.txt
```

## API Configuration

For API-based runs, copy the template and fill in your endpoint:

```bash
cp api_config.example.json api_config.json
```

For local vLLM runs, `api_config.json` is not needed when `vllm_base_url` is supplied.

## Main Evaluator Run

The paper's main setting uses Qwen3-8B as an OpenAI-compatible vLLM backend, memory version `v2`, no memory update, and the `v2` turn-evaluation prompt.

```bash
cd detection
model=Qwen/Qwen3-8B \
vllm_base_url=http://localhost:8000/v1 \
memory_update_mode=none \
memory_version=v2 \
turn_eval_prompt_version=v2 \
max_workers=4 \
output_jsonl=outputs/personalized/qwen3_8b_test_memory_v2_none.jsonl \
bash scripts/collect_personalized_vllm.sh
```

Evaluate the resulting predictions:

```bash
cd detection
result_file=outputs/personalized/qwen3_8b_test_memory_v2_none.jsonl \
bash scripts/eval_personalized.sh
```

## Baselines

The release includes the baseline entrypoints used in the paper:

```bash
cd detection
bash scripts/run_generic_llm_judge.sh
bash scripts/run_history_baselines.sh
bash scripts/run_personalized_spur.sh
```

Adjust the environment variables inside or before each script to select model names, output paths, and subsets.

## PersTurnBench Replay Pipeline

Collect candidate model responses on fixed conversation prefixes:

```bash
cd detection
candidate_model=gpt-5.5 \
bash scripts/collect_static_replay.sh
```

Score replay responses with the personalized evaluator:

```bash
cd detection
input_jsonl=outputs/static_replay/gpt-5.5_test_hard_responses.jsonl \
judge_model=Qwen/Qwen3-8B \
vllm_base_url=http://localhost:8000/v1 \
bash scripts/score_static_replay.sh
```

Compute aggregate benchmark results:

```bash
cd detection
bash scripts/eval_static_replay.sh
```

## Notes on Scope

This package keeps code required to run the paper-facing evaluator, baselines, post-hoc calibration utilities, and PersTurnBench replay evaluation.
Exploratory components such as model training pipelines, checkpoint directories, URS-specific pipelines, paper drafts, and intermediate outputs are excluded.
Some internal functions remain in shared modules when they are required by imports, but the recommended paper configuration is the no-update memory setting shown above.
