# Beyond Binary: Ternary Hardware for Efficient AI

**Authors:** Vincent G. Capone (vgc8903), Vanshika Agrawal (va2652)

> A multi-phase study of ternary {-1, 0, +1} weights for AI accelerators — from software accuracy (CIFAR-10/100) to silicon-level µm², ns, and µW on a 45nm process.

---

## TL;DR — Key Results

| Phase | Metric | Result |
|---|---|---|
| **Phase 1 (Software)** | CIFAR-100 accuracy | Ternary **62.02%** vs Baseline 61.18% **(+0.84%)** |
| **Phase 1 (Software)** | CIFAR-10 accuracy | Ternary **86.66%** vs Baseline 85.31% **(+1.35%)** |
| **Phase 1 (Software)** | Weight sparsity | **38% zeros** (skippable operations) |
| **Phase 2 (Hardware)** | Gate Equivalents | **51% reduction** (1144.5 → 561.0 GE) |
| **Phase 3 (Hardware)** | Chip area | **47% smaller** (866.6 → 463.9 µm²) |
| **Phase 3 (Hardware)** | Power consumption | **81% lower** (655.4 → 123.7 µW) |
| **Phase 3 (Hardware)** | Speed | **4% faster** (663.7 → 692.0 MHz) |
| **System-Level** | Energy per inference | **82% reduction** (1.180 → 0.223 mJ) |

### Headline Claim

> *Replacing an 8-bit signed multiplier with a 2-bit ternary multiplexer in a MAC unit reduces silicon area by 47%, power by 81%, and energy per CIFAR-100 inference by 82% — while improving accuracy by 0.84%.*

---

## Project Structure

```
beyond-binary-repo/
├── README.md                          # This file
├── LICENSE                            # MIT + CC-BY-4.0
├── SETUP.md                           # How to run notebooks
├── proposal.md                        # Original project proposal
│
├── rtl/                               # Verilog source code
│   ├── standard_mac.v                 # 8-bit multiplier MAC
│   ├── ternary_mac.v                  # 2-bit MUX-based MAC
│   └── tb_macs.v                      # Functional equivalence testbench
│
├── notebooks/                         # Google Colab notebooks
│   ├── phase1_resnet18_qat.ipynb      # Software: QAT on CIFAR-10/100
│   ├── phase2_hardware_mapping.ipynb  # Hardware: Yosys synthesis
│   ├── phase3_nangate45_opensta.ipynb # Hardware: Real silicon metrics
│   └── phase_bridge.ipynb             # Cross-phase analysis
│
├── results/                           # Documented results
│   ├── phase1_summary.md              # Software results
│   ├── phase2_results.md              # Normalized GE results
│   ├── phase3_results.md              # Real silicon results
│   └── unified_results.md             # All phases combined
│
└── docs/                              # Documentation
    └── workflow.md                    # How phases connect
```

---

## Quick Start

All notebooks run on **Google Colab** (free tier):

1. **Phase 1** (Software): `phase1_resnet18_qat.ipynb` — Needs GPU (~2 hours)
2. **Phase 2** (Hardware): `phase2_hardware_mapping.ipynb` — CPU only (~2 min)
3. **Phase 3** (Hardware): `phase3_nangate45_opensta.ipynb` — CPU only (~3 min)
4. **Bridge** (Analysis): `phase_bridge.ipynb` — CPU only (<1 min)

See [`SETUP.md`](SETUP.md) for detailed instructions.

---

## Detailed Results

### Phase 1: Software Feasibility (Quantization-Aware Training)

**Question:** Do ternary weights {-1, 0, +1} preserve accuracy?

**Answer:** Yes, and they actually **outperform** full-precision baselines.

| Dataset | Baseline (FP32) | Ternary {-1,0,+1} | Improvement |
|---|---|---|---|
| CIFAR-10 | 85.31% | **86.66%** | **+1.35%** |
| CIFAR-100 | 61.18% | **62.02%** | **+0.84%** |

**Weight Distribution after QAT:**
- 31% are -1
- **38% are 0** (skippable operations)
- 31% are +1

📄 [Full Phase 1 Results](results/phase1_summary.md)

---

### Phase 2: Hardware Mapping (Normalized Metrics)

**Question:** Is the ternary MAC smaller than the standard MAC?

**Answer:** Yes. **51% reduction** in normalized Gate Equivalents.

| Component | Standard MAC | Ternary MAC | Savings |
|---|---|---|---|
| **Gate Equivalents** | **1144.5** | **561.0** | **51% smaller** |
| XOR cells (multiplier) | 211 | 71 | 66% fewer |
| MUX cells (selector) | 0 | 10 | ternary only |
| Total cells | 696 | 303 | 56% fewer |

**Key Finding:** The standard MAC has 211 XOR/XNOR cells forming the multiplier's carry chain. The ternary MAC eliminates most of these, using only 71 XORs (in the accumulator) + 10 MUXes.

📄 [Full Phase 2 Results](results/phase2_results.md)

---

### Phase 3: Real Hardware Metrics (Nangate 45nm)

**Question:** What are the actual silicon-level numbers?

**Answer:** **47% smaller area, 81% less power, 4% faster.**

| Metric | Standard MAC | Ternary MAC | Improvement |
|---|---|---|---|
| **Chip Area** | 866.63 µm² | 463.90 µm² | **47% smaller** |
| **Total Power** | 655.37 µW | 123.66 µW | **81% lower** |
| Critical Path | 1.5067 ns | 1.4450 ns | 4% faster |
| Max Frequency | 663.7 MHz | 692.0 MHz | 4% faster |
| Cell Count | 634 | 278 | 56% fewer |

**Operating Conditions:**
- Process: Nangate 45nm Open Cell Library
- Voltage: 1.10V
- Temperature: 25°C
- Activity factor: Workload-aware (α=0.20 standard, α=0.124 ternary)

📄 [Full Phase 3 Results](results/phase3_results.md)

---

### System-Level Impact (Bridge Analysis)

**Setup:** ResNet-18 on CIFAR-100 (1.8 billion MAC operations per image)

**Single MAC Performance:**

| Metric | Standard | Ternary | Improvement |
|---|---|---|---|
| **Energy/inference** | 1.180 mJ | 0.223 mJ | **82% reduction** |
| Latency | 2.71 s | 2.60 s | 4% faster |

**4096-MAC Parallel Accelerator:**

| Metric | Standard | Ternary | Improvement |
|---|---|---|---|
| Chip Area | 3.42 mm² | 1.83 mm² | 47% smaller |
| Peak Power | 2.58 W | 0.488 W | 81% lower |
| Latency/image | 0.661 ms | 0.634 ms | 4% faster |

**At iso-accuracy (62.02% CIFAR-100)**, the ternary accelerator uses **1/6 the energy** of the standard one.

📄 [Full Unified Results](results/unified_results.md)

---

## Methodology Validation

Two completely independent methods measuring the same design:

| Method | Area Reduction |
|---|---|
| Phase 2: Yosys generic gates (normalized GE) | 51% |
| Phase 3: Nangate45 real cells (µm²) | 47% |
| **Agreement** | **4 percentage points** |

This cross-validation proves the area savings are a genuine property of the design, not a measurement artifact.

📄 [How Phases Connect](docs/workflow.md)

---

## What Makes This Work Different

Most ternary neural network papers stop at software accuracy. This work goes all the way to silicon:

1. ✅ **Software accuracy** (Phase 1) — proves ternary weights work
2. ✅ **Hardware design** (Phases 2 & 3) — proves they're cheaper in silicon
3. ✅ **Cross-validation** (Bridge #4) — two independent methods agree
4. ✅ **System-level analysis** (Bridge #1) — translates to real energy reduction
5. ✅ **Open-source reproducible** — all notebooks run on free Colab

---

## Track A vs Track B

**Track A (Completed — this work):**
- Quantized {-1, 0, +1} weights
- MUX-based MAC (no multiplier)
- Full software + hardware analysis

**Track B (Proposed future work):**
- Native multi-trit balanced ternary arithmetic
- MUX-bank partial product generation
- Radix economy advantages

See [`proposal.md`](proposal.md) for details.

---

## Citation

```bibtex
@misc{capone2025beyondbinary,
  title={Beyond Binary: Ternary Hardware for Efficient AI},
  author={Capone, Vincent G. and Agrawal, Vanshika},
  year={2025},
  note={Multi-phase study from software to silicon-level metrics}
}
```

---

## License

- **Code** (RTL, notebooks): MIT License
- **Documentation**: CC-BY-4.0
- **Nangate 45nm Library**: Apache 2.0 (NCSU/Si2)

---

## Contact

- Vincent G. Capone: vgc8903@nyu.edu
- Vanshika Agrawal: va2652@nyu.edu

Questions? Open an issue or email us.

---

## Acknowledgments

- Nangate 45nm Open Cell Library (NCSU/Si2)
- Yosys and OpenSTA open-source EDA tools
- ResNet-18 architecture (He et al., CVPR 2016)
