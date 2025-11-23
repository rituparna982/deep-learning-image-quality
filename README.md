# Deep Learning Classification of E-Commerce Product Image Quality

A deep-learning project for classifying the visual quality of e-commerce product images using convolutional neural networks and PyTorch.

## Overview

Product-image quality has a direct impact on customer trust, product presentation, and online purchasing decisions.

This project investigates the automatic classification of e-commerce product images into five visual-quality categories using deep-learning models.

The workflow includes dataset preparation, preprocessing, CNN training, evaluation, and error analysis.

## Research Objectives

- Classify product-image quality into five categories
- Compare baseline and transfer-learning models
- Evaluate performance using multiple classification metrics
- Analyze common model errors
- Investigate practical applications for e-commerce platforms

## Technologies

- Python
- PyTorch
- Torchvision
- scikit-learn
- NumPy
- Pandas
- Matplotlib
- Pillow

## Project Pipeline

```text
Product Images
      ↓
Data Cleaning and Labeling
      ↓
Image Preprocessing
      ↓
Training / Validation Split
      ↓
CNN or Transfer-Learning Model
      ↓
Model Training
      ↓
Prediction and Evaluation
      ↓
Confusion Matrix and Error Analysis
```

## Evaluation Metrics

The models are evaluated using:

- Accuracy
- Precision
- Recall
- F1-score
- Confusion matrix

## Current Status

- [x] Dataset organization
- [x] Image preprocessing
- [x] Baseline CNN implementation
- [x] Model training
- [x] Classification evaluation
- [ ] Transfer-learning comparison
- [ ] Hyperparameter optimization
- [ ] Extended error analysis

## Repository Structure

```text
data/
docs/
images/
models/
notebooks/
results/
src/
```

## Research Use

This repository presents a lightweight and reproducible version of the project.

The complete dataset and large trained-model files are not included because of storage, licensing, and data-management considerations.
## Quick Start

Clone the repository:

```bash
git clone https://github.com/rituparna982/deep-learning-image-quality.git
cd deep-learning-image-quality
```

Create and activate a virtual environment:

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
```

Linux or macOS:

```bash
source .venv/bin/activate
```

Install the dependencies:

```bash
pip install -r requirements.txt
```

Organize the dataset using the following structure:

```text
data/dataset/
├── blurry/
├── dark/
├── low_resolution/
├── poor_background/
└── good_quality/
```

Run training:

```bash
python src/train.py --config config.example.json
```

The best model checkpoint will be saved to:

```text
models/best_baseline_cnn.pt
```

## Author

**Author:** Rituparna Satpathy ([@rituparna982](https://github.com/rituparna982))

MSc Student in Smart Systems Engineering  
An-Najah National University, Palestine

- GitHub: [@rituparna982](https://www.linkedin.com/in/rituparna982/)
- Email: s12154757@stu.najah.edu
