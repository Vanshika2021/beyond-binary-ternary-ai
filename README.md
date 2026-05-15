# Beyond Binary: Ternary Hardware for Efficient AI Inference

**Authors:** Vincent G. Capone (vgc8903), Vanshika Agrawal (va2652)
> A multi-phase study of ternary {-1, 0, +1} weights for AI accelerators — from software accuracy (CIFAR-10/100) to silicon-level µm², ns, and µW on a 45nm process. Extended to multi-trit balanced ternary (Track B), identifying 3-trit as the Pareto-optimal sweet spot.

---

## TL;DR — Key Results

### Track A (Single-Trit)

| Phase | Metric | Result |
|-------|--------|--------|
| **Phase 1 (Software)** | CIFAR-100 accuracy | Ternary **62.02%** vs Baseline 61.18% **(+0.84%)** |
| **Phase 1 (Software)** | CIFAR-10 accuracy | Ternary **86.66%** vs Baseline 85.31% **(+1.35%)** |
| **Phase 1 (Software)** | Weight sparsity | **38% zeros** (skippable operations) |
| **Phase 2 (Hardware)** | Gate Equivalents | **51% reduction** (1144.5 → 561.0 GE) |
| **Phase 3 (Hardware)** | Chip area | **47% smaller** (866.63 → 463.90 µm²) |
| **Phase 3 (Hardware)** | Power consumption | **81% lower** (655.37 → 123.66 µW) |
| **Phase 3 (Hardware)** | Speed | **4% faster** (663.7 → 692.0 MHz) |
| **System-Level** | Energy per inference | **82% reduction** (1.777 → 0.322 mJ) |

### Track B (Multi-Trit) ✅

| Precision | Cells | Transistors | vs Binary | CIFAR-10 |
|-----------|-------|-------------|-----------|----------|
| 1-trit (Track A) | 303 | — | −78% | 86.66% |
| **3-trit ★** | **996** | **3,682** | **−26%** | **90.50%** |
| 4-trit | 1,457 | 5,488 | +8% | — |
| Binary INT8 | 1,351 | 4,970 | baseline | 85.31% |

**3-trit sweet spot:** 26% cheaper than INT8, 27 weight levels, higher accuracy than both INT8 and 1-trit.

### Headline Claim
> *Replacing an 8-bit signed multiplier with a 2-bit ternary multiplexer in a MAC unit reduces silicon area by 47%, power by 81%, and energy per CIFAR-100 inference by 82% — while improving accuracy by 0.84%. Extending to 3-trit weights achieves 27 precision levels at 26% hardware savings versus binary.*

---

## Project Structure

```
beyond-binary-ternary-ai/
├── README.md                               # This file
├── LICENSE                                 # MIT
├── Proposal.md                             # Original project proposal
├── QUICK_START.md                          # How to run notebooks
│
├── Track A - Phase_1_ternary_nn_cifar10_resnet18.ipynb   # Phase 1 QAT (CIFAR-10)
├── Track A - phase1_resnet18_qat_ipynb.ipynb             # Phase 1 QAT (CIFAR-100)
├── Track A - phase2_hardware_mapping.ipynb               # Phase 2 Yosys GE synthesis
├── Track A - phase3_nangate45_opensta.ipynb              # Phase 3 real silicon
├── Track A - phase_bridge.ipynb                          # Bridge energy analysis
├── Track B - Phase1_Colab.ipynb                          # Track B QAT training
├── Track B - Phase2.ipynb                                # Track B Yosys synthesis
│
├── rtl/                               # Verilog source code
│   ├── standard_mac.v                 # 8-bit multiplier MAC
│   ├── ternary_mac.v                  # 2-bit MUX-based MAC (Track A)
│   └── tb_macs.v                      # Functional equivalence testbench
│
├── results/                           # Documented results
│   ├── phase1_summary.md              # Track A software results
│   ├── trackb_results.md              # Track B hardware + software results
│   └── unified_results.md             # All phases + both tracks combined
│
└── notebooks/                         # Additional notebooks folder
```

---

## Quick Start

All notebooks run on **Google Colab** (free tier):

### Track A
1. **Phase 1** (Software): `Track A - phase1_resnet18_qat_ipynb.ipynb` — GPU (~2 hours)
2. **Phase 2** (Hardware): `Track A - phase2_hardware_mapping.ipynb` — CPU (~2 min)
3. **Phase 3** (Hardware): `Track A - phase3_nangate45_opensta.ipynb` — CPU (~3 min)
4. **Bridge** (Analysis): `Track A - phase_bridge.ipynb` — CPU (<1 min)

### Track B
5. **Phase 1** (Software): `Track B - Phase1_Colab.ipynb` — GPU
6. **Phase 2** (Hardware): `Track B - Phase2.ipynb` — CPU

---

## Detailed Results

### Phase 1: Software Feasibility (QAT)

**Question:** Do ternary weights {-1, 0, +1} preserve accuracy?
**Answer:** Yes — they **outperform** full-precision baselines.

| Dataset | Baseline (FP32) | Ternary QAT | Improvement |
|---------|----------------|-------------|-------------|
| CIFAR-10 | 85.31% | **86.66%** | **+1.35%** |
| CIFAR-100 | 61.18% | **62.02%** | **+0.84%** |

Weight distribution after QAT: 31% are −1, **38% are 0** (skippable), 31% are +1.

---

### Phase 2: Hardware Mapping (Normalized Metrics)

**Question:** Is the ternary MAC smaller?
**Answer:** Yes — **51% reduction** in Gate Equivalents.

| Component | Standard MAC | Ternary MAC | Savings |
|-----------|-------------|-------------|---------|
| **Gate Equivalents** | **1144.5** | **561.0** | **51% smaller** |
| XOR cells (multiplier) | 211 | 71 | 66% fewer |
| MUX cells | 0 | 10 | ternary only |
| Total cells | 696 | 303 | 56% fewer |

---

### Phase 3: Real Silicon Metrics (Nangate 45nm)

**Question:** What are the actual silicon numbers?
**Answer:** **47% smaller area, 81% less power, 4% faster.**

| Metric | Standard MAC | Ternary MAC | Improvement |
|--------|-------------|-------------|-------------|
| **Chip Area** | 866.63 µm² | 463.90 µm² | **47% smaller** |
| **Total Power** | 655.37 µW | 123.66 µW | **81% lower** |
| Critical Path | 1.5067 ns | 1.4450 ns | 4% faster |
| Max Frequency | 663.7 MHz | 692.0 MHz | 4% faster |

Operating conditions: Nangate 45nm Open Cell Library, 1.10V, 25°C typical corner.

---

### Bridge: System-Level Energy

ResNet-18 on CIFAR-100 (1.8 billion MACs per image):

| Metric | Standard | Ternary | Improvement |
|--------|----------|---------|-------------|
| **Energy/inference** | **1.777 mJ** | **0.322 mJ** | **82% reduction** |
| Power | 655.37 µW | 123.66 µW | 81% lower |
| Latency | 2.71 s | 2.60 s | 4% faster |

---

### Track B: Multi-Trit Balanced Ternary

**Question:** At what precision does ternary hardware stop being cheaper than binary?
**Answer:** Crossover at 3→4 trits. **3-trit is the sweet spot.**

| Precision | Cells | Transistors | vs Binary | CIFAR-10 | CIFAR-100 |
|-----------|-------|-------------|-----------|----------|-----------|
| 1-trit | 303 | — | −78% | 86.66% | 62.02% |
| 2-trit | 612 | — | −55% | 89.64% | 69.99% |
| **3-trit ★** | **996** | **3,682** | **−26%** | **90.50%** | ~70% |
| 4-trit | 1,457 | 5,488 | +8% | — | — |
| 5-trit | 1,924 | 7,318 | +42% | — | — |
| Binary INT8 | 1,351 | 4,970 | baseline | 85.31% | 61.18% |

📄 [Full Track B Results](./results/trackb_results.md)

---

## Methodology Validation

| Method | Area Reduction |
|--------|---------------|
| Phase 2: Yosys generic gates (GE) | 51% |
| Phase 3: Nangate45 real cells (µm²) | 47% |
| **Agreement** | **4 percentage points** |

Two completely independent methods agree — proving the savings are genuine, not a tool artifact.

---

## Track A vs Track B Summary

| | Track A (1-trit) | Track B (3-trit) | Binary INT8 |
|-|-----------------|-----------------|-------------|
| Weight levels | 3 | 27 | 256 |
| Cells (Yosys) | 303 | 996 | 1,351 |
| Hardware vs binary | −78% | **−26%** | baseline |
| CIFAR-10 accuracy | 86.66% | **90.50%** | 85.31% |
| CIFAR-100 accuracy | 62.02% | ~70% | 61.18% |
| Nangate45 metrics | ✅ Full | ⏳ Pending | ✅ Full |

---

## Citation

```bibtex
@misc{capone2025beyondbinary,
  title={Beyond Binary: Ternary Hardware for Efficient AI Inference},
  author={Capone, Vincent G. and Agrawal, Vanshika},
  year={2025},
  note={Multi-phase study from software to silicon. NYU Tandon School of Engineering.}
}
```

---

## License

- **Code** (RTL, notebooks): MIT License
- **Nangate 45nm Library**: Apache 2.0 (NCSU/Si2)

## Contact

- Vincent G. Capone: vgc8903@nyu.edu
- Vanshika Agrawal: va2652@nyu.edu

## Acknowledgments

- Nangate 45nm Open Cell Library (NCSU/Si2)
- Yosys and OpenSTA open-source EDA tools
- ResNet-18 architecture (He et al., CVPR 2016)
