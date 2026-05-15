# Phase 1 Results — Software Feasibility

**Research Question:** Do ternary weights {-1, 0, +1} preserve classification accuracy?

**Answer:** Yes. Ternary weights **outperform** full-precision baselines on both CIFAR-10 and CIFAR-100.

---

## Key Results

| Dataset | Baseline (FP32) | Ternary {-1,0,+1} | Δ |
|---|---|---|---|
| **CIFAR-10** | 85.31% | **86.66%** | **+1.35%** |
| **CIFAR-100** | 61.18% | **62.02%** | **+0.84%** |

---

## Weight Distribution (Trained Ternary Network)

After Quantization-Aware Training (QAT) at α = 0.10:

| Value | Fraction | Count (11M weights) |
|---|---|---|
| -1 | 31% | ~3.4M |
| **0** | **38%** | **~4.2M** |
| +1 | 31% | ~3.4M |

**38% sparsity** means 38% of all multiply operations can be completely skipped.

---

## Methodology

### Model Architecture
- **Model:** ResNet-18 (11 million weights)
- **Input:** 32×32×3 CIFAR images
- **Output:** 10 classes (CIFAR-10) or 100 classes (CIFAR-100)

### Quantization-Aware Training (QAT)

**Forward pass:**
```python
def ternary_quantize(w, alpha):
    return torch.sign(w) * (torch.abs(w) > alpha).float()
```

**Backward pass:** Straight-through estimator
- Gradients flow through the quantized weights as if they were continuous
- Enables end-to-end training despite non-differentiable quantization

**Temperature annealing:**
- α starts at 0.10
- Decays to 0.01 over 100 epochs
- Encourages sparser solutions as training progresses

### Training Details
- **Optimizer:** SGD with momentum (0.9)
- **Learning rate:** 0.1 with step decay
- **Batch size:** 128
- **Epochs:** 100
- **Data augmentation:** Random crop + horizontal flip
- **Framework:** PyTorch

---

## Why QAT is Essential

### Post-Training Quantization (PTQ) Fails

Naively rounding a pre-trained FP32 network to {-1, 0, +1}:

| Dataset | Baseline | PTQ | QAT |
|---|---|---|---|
| CIFAR-10 | 85.31% | ~60% | **86.66%** |
| CIFAR-100 | 61.18% | **30.10%** | **62.02%** |

**PTQ → QAT recovery on CIFAR-100: +30.92 percentage points**

PTQ alone is completely unusable. QAT recovers full accuracy and surpasses the baseline.

---

## Workload Characterization

### MAC Operations per Inference

ResNet-18 on 32×32 CIFAR input: **~1.8 × 10⁹ MAC operations** per forward pass

> Reference: He et al., "Deep Residual Learning for Image Recognition," CVPR 2016

### Implications for Hardware

With 38% weight sparsity:
- **4.2 million multiply operations eliminated** per inference
- Remaining 62% only need add/subtract (no multiplication)
- This drives the power savings in Phase 3

---

## Connection to Hardware Phases

| Finding | Feeds into | Impact |
|---|---|---|
| 38% sparsity | Phase 3 power analysis | Lower activity factor (α) for ternary MAC |
| 1.8B MACs/image | Bridge analysis | Total energy per inference calculation |
| {-1, 0, +1} only | Phase 2/3 design | Eliminates multiplier entirely |

---

## Reproducibility

See `notebooks/phase1_resnet18_qat.ipynb` for complete code.

**Runtime:** ~2 hours on Google Colab free GPU (Tesla T4)

**Random seeds:** Fixed for reproducibility
