# OpenWrt Kernel Memory Leak Analyzer using Claude

## 💡 Project Goal

This project provides a robust, LLM-driven method for detecting specific kernel memory leaks in OpenWrt based on a custom expert-defined threshold for the `SUnreclaim` slab memory. It utilizes Claude Opus 4.5 for deep time-series analysis of `/proc/meminfo` logs.

## 🔬 Methodology: SUnreclaim Threshold

The analysis focuses on the `SUnreclaim` metric, which tracks kernel slab memory that is explicitly marked as non-reclaimable (often associated with network buffers or device drivers).

| Metric | Status | Description |
| :--- | :--- | :--- |
| **30 MB - 35 MB** | **Normal Usage** | SUnreclaim stabilizes within this range. Indicates normal skb recycler usage, not a leak. |
| **> 40 MB** | **Leak CONFIRMED** | SUnreclaim continuously grows and exceeds this critical threshold. Indicates a persistent kernel memory leak. |

## 🚀 Usage

### Prerequisites

1.  **Claude CLI:** You must have the `claude` command-line tool installed and configured with the Anthropic API key.
2.  **Log Files:** Place your OpenWrt `/proc/meminfo` logs into the `data/` directory.

### Running the Analysis

1.  **Grant Execution:**
    ```bash
    chmod +x scripts/run_analysis.sh
    ```
2.  **Execute Script:**
    ```bash
    ./scripts/run_analysis.sh
    ```
3.  **Review Output:** The full analysis report will be saved to `analysis_results/memory_leak_report.md`.

## 📋 Example Analysis Summary

The following summary is based on the provided `sysinfo-Pinnacle2.0-0.txt` and `sysinfo-Pinnacle2.0-1.txt` logs, demonstrating the effectiveness of the template.

---

### Final Verdict: **Memory Leak Detected**

**Type:** SUnreclaim Kernel Slab Leak (likely skb recycler or network-related kernel cache)

**Evidence Summary:**
1.  **SUnreclaim Levels:** The observed SUnreclaim values (99.66 MB to 105.71 MB) are approximately **3x higher** than the normal stabilization range (30-35 MB).
2.  **Threshold Violation:** The memory usage **far exceeds** the critical **40 MB leak threshold**.
3.  **Growth Trend:** Continuous growth was observed (+6 MB over 20 hours) with a persistent, non-recovering decline in `MemAvailable`.
