# Beyond Binary: Ternary Hardware for Efficient AI Inference

**Project Proposal**  
NYU Tandon School of Engineering — Computer Engineering  
Vanshika Agrawal · Vincent Capone

---

## Motivation

Modern deep neural networks require billions of multiply-accumulate (MAC) operations per inference. On standard 8-bit binary hardware, each MAC requires a full 8×8 bit multiplier — expensive in area and power.

AI energy demand is projected to grow ~3× by 2030, with compute alone accounting for ~30% of datacenter power today. Efficient inference hardware is critical for both edge deployment and sustainable AI at scale.

---

## Hypothesis

> **Ternary-quantized weights $\{-1, 0, +1\}$ replace expensive multipliers with mux-based operations, enabling significant area and power reduction with no accuracy loss.**

Extending to multi-trit precision ($k$-trit balanced ternary) could achieve better accuracy while keeping hardware cheaper than INT8 binary.

---

## Approach

### Track A — Single-Trit Ternary MAC

- Restrict network weights to $\{-1, 0, +1\}$ (1 trit each)
- Replace the 8-bit binary multiplier with a 3-way MUX
- Validate accuracy preservation via Quantization-Aware Training (QAT)
- Measure hardware savings via Yosys (Gate Equivalents) and Nangate 45nm (real silicon)

### Track B — Multi-Trit Balanced Ternary MAC

- Extend to $k$-trit weights ($k \in \{1, 2, 3, 4, 5\}$)
- $k=3$ provides 27 distinct levels (vs 3 for Track A, 256 for INT8)
- Multiplication: $W \times x = \sum_i (w_i \times x) \cdot 3^i$ — each term a MUX, scaling via shift-add
- Identify the Pareto-optimal point: cheapest hardware that's still better than INT8

---

## Methodology

### Phase 1 — Software Validation
- Train ResNet-18 on CIFAR-10 and CIFAR-100
- Quantization-Aware Training (QAT) with Straight-Through Estimator (STE)
- Measure: top-1 accuracy, weight sparsity, weight distribution

### Phase 2 — Hardware Mapping (Normalized)
- Implement Standard MAC and Ternary MAC in Verilog RTL
- Synthesize with Yosys (`cmos2` generic library)
- Measure: Gate Equivalents (GE), cell counts by type
- Verify functional equivalence via testbench (40+ test vectors)

### Phase 3 — Real Silicon Characterization
- Synthesize to Nangate 45nm Open Cell Library
- Timing analysis: OpenSTA (critical path, max frequency)
- Power analysis: OpenSTA (generic and workload-aware activity factors)
- Measure: Area (µm²), timing (ns), power (µW)

### Bridge — System-Level Analysis
- Combine Phase 1 sparsity (38% zero weights) with Phase 3 power
- Compute energy per CIFAR-100 inference: $E = P \times t$
- Scale to 4096-MAC systolic array

---

## Expected Outcomes

| Metric | Target |
|--------|--------|
| CIFAR-100 accuracy | Match or exceed FP32 baseline (61.18%) |
| Area reduction (Track A) | > 40% vs INT8 MAC |
| Power reduction (Track A) | > 70% vs INT8 MAC |
| Track B sweet spot | 3-trit: hardware cheaper than INT8, more levels than 1-trit |

---

## Team

| Member | NetID | Primary Responsibility |
|--------|-------|------------------------|
| Vanshika Agrawal | va2652 | Phase 2 (RTL/Synthesis), Track B |
| Vincent Capone | vgc8903 | Phase 1 (QAT Training), Phase 3 (Nangate45) |

---

## Repository Structure

```
beyond-binary-ternary-ai/
├── rtl/                    # Verilog RTL source files
│   ├── standard_mac.v      # Baseline 8-bit MAC
│   ├── ternary_mac.v       # Single-trit ternary MAC (Track A)
│   └── tb_macs.v           # Verification testbench
├── results/
│   ├── phase1_summary.md   # QAT software results
│   ├── phase2_results.md   # Gate Equivalent analysis
│   ├── phase3_results.md   # Nangate45 real silicon metrics
│   ├── trackb_results.md   # Multi-trit Track B results
│   └── unified_results.md  # Cross-phase summary
├── notebooks/              # Jupyter notebooks for QAT training
├── docs/
│   └── workflow.md         # Detailed methodology
├── proposal.md             # This file
├── README.md               # Repository overview
└── SETUP.md                # Environment setup instructions
```

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1-2  | Phase 1: QAT training, accuracy validation |
| 3-4  | Phase 2: RTL design, Yosys synthesis, GE analysis |
| 5-6  | Phase 3: Nangate45 synthesis, OpenSTA |
| 7    | Bridge: System-level energy analysis |
| 8    | Track B: Multi-trit synthesis and accuracy |
| 9    | Report writing and final submission |

---

## References

1. Courbariaux et al., "BinaryConnect," NeurIPS 2015
2. Hubara et al., "Quantized Neural Networks," arXiv 2016
3. He et al., "Deep Residual Learning," CVPR 2016
4. Jacob et al., "Quantization and Training of Neural Networks," CVPR 2018
5. Nangate 45nm Open Cell Library, NCSU/Si2
