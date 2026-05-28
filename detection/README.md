# PersTurnBench Detection Code

Run commands from this directory unless otherwise noted.
The default data path is `../data`, relative to the release root.

Recommended paper-facing entrypoints:

- `scripts/collect_personalized_vllm.sh`: collect personalized evaluator predictions with an OpenAI-compatible vLLM endpoint.
- `scripts/eval_personalized.sh`: evaluate personalized evaluator predictions against turn-level satisfaction labels.
- `scripts/run_generic_llm_judge.sh`: run generic LLM-as-a-judge baselines.
- `scripts/run_history_baselines.sh`: run user-history and retrieval baselines.
- `scripts/run_personalized_spur.sh`: run the SPUR-style baseline.
- `scripts/collect_static_replay.sh`: collect candidate responses for PersTurnBench replay items.
- `scripts/score_static_replay.sh`: score replay responses with the frozen personalized evaluator.
- `scripts/eval_static_replay.sh`: compute aggregate PersTurnBench metrics.
- `scripts/calibrate_static_replay_reference.sh`: apply reference-CDF score calibration for replay outputs.

The release root `README.md` contains the recommended end-to-end commands.
