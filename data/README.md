# Dataset

The original research dataset is not included in this repository because of storage limitations and research data management.

## Expected Dataset Structure

```text
data/
└── dataset/
    ├── blurry/
    ├── dark/
    ├── low_resolution/
    ├── poor_background/
    └── good_quality/
```

Users can organize their own dataset using the above structure.

The training pipeline automatically loads datasets using the standard PyTorch ImageFolder format.
