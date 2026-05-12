# Notebooks Directory

⚠️ **ACTION REQUIRED:** Upload the notebook files here

---

## Required Notebooks

Please add the following `.ipynb` files from your Google Drive:

1. **`phase1_resnet18_qat.ipynb`**
   - Source: `Track A - phase1_resnet18_qat_ipynb.ipynb` or the `_fixed` version
   - What it does: Trains ResNet-18 with QAT on CIFAR-10/100
   - Runtime: ~2 hours (GPU required)

2. **`phase2_hardware_mapping.ipynb`**
   - Source: `Track A - phase2_hardware_mapping.ipynb`
   - What it does: Synthesizes both MACs with Yosys, counts gates
   - Runtime: ~2 minutes (CPU only)

3. **`phase3_nangate45_opensta.ipynb`**
   - Source: `Track A - phase3_nangate45_opensta.ipynb`
   - What it does: Real silicon metrics with Nangate45 + OpenSTA
   - Runtime: ~3 minutes (CPU only)

4. **`phase_bridge.ipynb`**
   - Source: `Track A - phase_bridge.ipynb`
   - What it does: Cross-phase analysis and validation
   - Runtime: <1 minute (CPU only)

---

## How to Add Notebooks

### Option A: Download from Google Drive
1. Right-click each notebook in Google Drive
2. Select "Download"
3. Rename to match the filenames above
4. Copy to this `notebooks/` directory

### Option B: Export from Colab
1. Open each notebook in Colab
2. File → Download → Download .ipynb
3. Save with the correct filename
4. Copy to this directory

---

## After Adding Notebooks

Once all notebooks are in place, you can:

1. Test them locally or in Colab
2. Commit to git: `git add notebooks/*.ipynb`
3. Push to GitHub: `git commit -m "Add Phase 1-3 and Bridge notebooks" && git push`

---

## Notebook Descriptions

### Phase 1: `phase1_resnet18_qat.ipynb`

**Purpose:** Prove ternary weights work in software

**What it does:**
- Implements ternary quantization function
- Trains ResNet-18 on CIFAR-10/100 with QAT
- Reports accuracy vs baseline
- Measures weight sparsity (fraction of zeros)

**Key outputs:**
- CIFAR-10: 86.66% (vs 85.31% baseline)
- CIFAR-100: 62.02% (vs 61.18% baseline)
- Weight sparsity: 38%

---

### Phase 2: `phase2_hardware_mapping.ipynb`

**Purpose:** Compare hardware complexity (normalized metrics)

**What it does:**
- Writes Verilog modules (`standard_mac.v`, `ternary_mac.v`)
- Runs functional verification testbench
- Synthesizes with Yosys to generic gates
- Counts cells and computes Gate Equivalents (GE)
- Generates comparison plots

**Key outputs:**
- Standard MAC: 1144.5 GE (696 cells, 211 XORs)
- Ternary MAC: 561.0 GE (303 cells, 71 XORs)
- **51% GE reduction**

---

### Phase 3: `phase3_nangate45_opensta.ipynb`

**Purpose:** Measure real silicon metrics

**What it does:**
- Downloads Nangate 45nm library
- Synthesizes both MACs to real cell library
- Runs timing analysis (OpenSTA)
- Runs power analysis (generic and workload-aware α)
- Generates comparison plots

**Key outputs:**
- Area: 866.6 → 463.9 µm² (**47% reduction**)
- Power: 655.4 → 123.7 µW (**81% reduction**)
- Speed: 663.7 → 692.0 MHz (**4% faster**)

---

### Bridge: `phase_bridge.ipynb`

**Purpose:** Connect all phases into system-level analysis

**What it does:**
- Loads results from Phases 1, 2, 3
- Computes energy per CIFAR-100 inference
- Adjusts power for workload-aware activity factor
- Scales to 4096-MAC parallel accelerator
- Cross-validates Phase 2 (GE) vs Phase 3 (µm²)

**Key outputs:**
- Energy/inference: 1.180 → 0.223 mJ (**82% reduction**)
- 4096-MAC accelerator: 3.42 → 1.83 mm² area
- Methodology validation: 51% vs 47% (4 pp agreement)

---

## Common Issues

**"Module not found" errors**
→ The notebooks install dependencies automatically in the first cell
→ Make sure to run cells in order from top to bottom

**"File not found" for Liberty/Verilog files**
→ Phase 2/3 notebooks create these files automatically
→ Don't skip the file-writing cells

**Phase 1 runs out of GPU memory**
→ Reduce batch size from 128 to 64
→ Or use Colab Pro for more VRAM

---

## Questions?

See [`../SETUP.md`](../SETUP.md) for detailed setup instructions.

Contact:
- Vincent: vgc8903@nyu.edu
- Vanshika: va2652@nyu.edu
