# Quick Setup Instructions

## Step 1: Download This Repo

1. Download `beyond-binary-repo.zip` from this chat
2. Unzip it locally

## Step 2: Add Your Notebooks

Download these 4 files from your Google Drive and add them to the `notebooks/` folder:

- `Track A - phase1_resnet18_qat_ipynb.ipynb` → rename to `phase1_resnet18_qat.ipynb`
- `Track A - phase2_hardware_mapping.ipynb` → rename to `phase2_hardware_mapping.ipynb`
- `Track A - phase3_nangate45_opensta.ipynb` → rename to `phase3_nangate45_opensta.ipynb`
- `Track A - phase_bridge.ipynb` → rename to `phase_bridge.ipynb`

## Step 3: Push to GitHub

```bash
cd beyond-binary-repo

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Beyond Binary ternary AI project"

# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR-USERNAME/beyond-binary-ternary-ai.git

# Push
git branch -M main
git push -u origin main
```

## What's Included

✅ Complete README with all results
✅ All RTL files (standard_mac.v, ternary_mac.v, testbench)
✅ Results documentation (Phase 1, 2, 3, unified)
✅ Workflow documentation
✅ License files (MIT + CC-BY-4.0)
✅ .gitignore properly configured

## What You Need to Add

📝 The 4 notebook files (see Step 2)

## Next Steps

Once on GitHub:
1. Verify everything renders correctly
2. Add link to report (when ready)
3. Share on resume/LinkedIn/applications

---

Need help? Email:
- Vincent: vgc8903@nyu.edu
- Vanshika: va2652@nyu.edu
