# PersTurnBench

PersTurnBench is a research code and data release for personalized turn-level user conversation satisfaction evaluation.
It supports the experiments in the paper *Personalized Turn-Level User Conversation Satisfaction Benchmark*.

The repository contains the paper-facing evaluator, baseline, calibration, and replay-evaluation pipelines.
The released data are distributed separately through Zenodo and should be placed next to the `detection/` directory before running the main scripts.

## What Is Included

- A memory-based conversation satisfaction evaluator for predicting turn-level user satisfaction.
- Baselines including generic LLM-as-a-judge, user-history retrieval, and SPUR-style evaluation.
- PersTurnBench replay scripts for comparing candidate LLM responses under fixed personalized conversation states.
- Post-hoc calibration and aggregate benchmark metric utilities.
- Plotting scripts for the paper figures.

This repository intentionally excludes model checkpoints, raw payment/contact information, exploratory notebooks, draft paper files, and intermediate experiment outputs.

## Repository Layout

```text
.
├── detection/
│   ├── lib/        # data loading, user memory, prompts, calibration, metrics
│   ├── trace/      # evaluator inference and replay scoring pipelines
│   ├── eval/       # evaluator verification, baselines, replay metrics
│   ├── scripts/    # shell entrypoints for the main paper experiments
│   └── assets/     # plotting scripts
├── api_config.example.json
├── requirements.txt
└── README.md
```

## Data

The anonymized PersTurnBench data release is available on Zenodo:

<https://zenodo.org/records/20391777>

After downloading the data archive, extract it into the repository root and move the `data/` directory next to `detection/`:

```bash
tar -xzf persturnbench_data_release_20260526.tar.gz
mv persturnbench_data_release_20260526/data ./data
```

The expected layout is:

```text
data/
detection/
api_config.example.json
requirements.txt
```

The data contain anonymized user IDs, task contexts, structured user profiles, conversation trajectories, turn-level satisfaction scores, and categorical dissatisfaction reasons for low-satisfaction turns.
See the data archive's `DATA_SCHEMA.md`, `statistics.json`, and `splits.json` for the released schema, aggregate statistics, and user-level split metadata.

## Installation

Create a Python environment and install the released dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

The main evaluator uses an OpenAI-compatible API interface.
For local experiments, we used Qwen3-8B served by vLLM.

## API Configuration

For API-based runs, copy the template and fill in your endpoint:

```bash
cp api_config.example.json api_config.json
```

For local vLLM runs, `api_config.json` is not required when `vllm_base_url` is supplied through the command line or environment variables.

## Quick Start

Run commands from the `detection/` directory unless otherwise noted.

### 1. Run the Main Evaluator

The paper-facing low-cost configuration uses Qwen3-8B, structured user memory, no target-scenario memory update, and the `v2` turn-evaluation prompt:

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

### 2. Run Baselines

The release includes the baseline entrypoints used in the paper:

```bash
cd detection
bash scripts/run_generic_llm_judge.sh
bash scripts/run_history_baselines.sh
bash scripts/run_personalized_spur.sh
```

Adjust environment variables inside or before each script to select model names, output paths, and subsets.

### 3. Run PersTurnBench Replay Evaluation

Collect candidate model responses on fixed replay prefixes:

```bash
cd detection
candidate_model=gpt-5.5 \
bash scripts/collect_static_replay.sh
```

Score replay responses with the frozen personalized evaluator:

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

Optional reference-CDF calibration can be run with:

```bash
cd detection
bash scripts/calibrate_static_replay_reference.sh
```

## Reproducibility Notes

- The main personalized evaluator split is recorded in the data release `splits.json`.
- The paper's main local evaluator backbone is `Qwen/Qwen3-8B`.
- The default benchmark reporting uses reference-CDF calibrated evaluator scores.
- Full LLM generation and scoring require an available OpenAI-compatible endpoint or local vLLM service.
- Some scripts expose additional environment variables for limits, output paths, model names, and worker counts.

## Intended Use

PersTurnBench is intended for research on personalized conversation evaluation and benchmark development.
It should be used as a reproducible screening layer for model comparison, not as a deployment-time substitute for direct consented user feedback.

## Citation

If you use this repository, please cite the paper once the final citation is available.

```bibtex
@misc{persturnbench,
  title = {Personalized Turn-Level User Conversation Satisfaction Benchmark},
  author = {Anonymous},
  year = {2026},
  note = {Code and data release}
}
```

The main real-user conversation collection is based on the data source used in *Human vs. Agent in Task-Oriented Conversations*.

## License

See `LICENSE` for the repository license.
