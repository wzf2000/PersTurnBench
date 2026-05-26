"""Compatibility entrypoint for personalized satisfaction evaluation."""

from __future__ import annotations

import os
import sys

_DETECTION_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _DETECTION_DIR not in sys.path:
    sys.path.insert(0, _DETECTION_DIR)

from eval.personalized import (
    DSAT_LABEL,
    SAT_LABEL,
    _fmt,
    boundary_stratified_analysis,
    compute_boundary_metrics,
    compute_global_metrics,
    compute_personalization_gain,
    evaluate_single,
    get_sat_confidence,
    load_records,
    main,
    per_user_personalization_gain,
    print_boundary_comparison_table,
    print_boundary_metrics,
    print_boundary_stratified_analysis,
    print_comparison_table,
    print_global_metrics,
    print_personalization_gain,
    print_stratified_analysis,
    stratified_analysis,
    to_binary_sat,
)

__all__ = [
    "DSAT_LABEL",
    "SAT_LABEL",
    "_fmt",
    "boundary_stratified_analysis",
    "compute_boundary_metrics",
    "compute_global_metrics",
    "compute_personalization_gain",
    "evaluate_single",
    "get_sat_confidence",
    "load_records",
    "main",
    "per_user_personalization_gain",
    "print_boundary_comparison_table",
    "print_boundary_metrics",
    "print_boundary_stratified_analysis",
    "print_comparison_table",
    "print_global_metrics",
    "print_personalization_gain",
    "print_stratified_analysis",
    "stratified_analysis",
    "to_binary_sat",
]


if __name__ == "__main__":
    main()
