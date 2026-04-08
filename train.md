
# 2) Model Trainer Developer Documentation (Training + Artifacts)

## 2.1 Purpose of the Trainer Component

Your job is to:

*   train the ML model (XGBoost-based),
*   preserve **preprocessing + label encoding** artifacts,
*   export a reproducible artifact bundle for inference,
*   and keep training aligned with the dataset label space used in demo:
    `BENIGN, DoS, PortScan, BruteForce, WebAttack, Bot, Infiltration`.

## 2.2 Paper vs What We Implemented (Training View)

### What the paper proposes

A full AutoML IDS:

*   AutoDP with TVAE balancing
*   AutoFE with tree-based feature importance averaging
*   model selection among DT/RF/ET/XGBoost/LightGBM/CatBoost
*   BO-TPE hyperparameter optimization
*   OCSE stacking ensemble using model confidence values [\[ieee-dataport.org\]](https://ieee-dataport.org/documents/cicids2017)

### What we implemented

A **representative subset** of the pipeline:

*   **single tree-based model** (XGBoost) to reduce runtime and enable fast demo.
*   preprocessing pipeline + transformations saved for inference consistency.
*   optional class balancing done via simpler methods (as used in our notebook).

We explicitly acknowledge we did **not fully reproduce** TVAE + BO-TPE + OCSE in code, but we remain aligned to the paper’s candidate model set by using XGBoost. [\[ieee-dataport.org\]](https://ieee-dataport.org/documents/cicids2017)

## 2.3 What You Own (Trainer Responsibilities)

*   `train_xgb.ipynb` or `train_xgb.py` (training workflow)
*   artifact exports into `/artifacts/`
*   metadata integrity (`metadata.json`)
*   consistent feature order between training and inference

## 2.4 Required Outputs (Artifacts)

Your training must produce:

*   `artifacts/xgboost_model.joblib`
*   `artifacts/preprocessor.joblib`
*   `artifacts/yeo_transformer.joblib`
*   `artifacts/label_encoder.joblib`
*   `artifacts/metadata.json` containing:
    *   `raw_feature_names`
    *   class mapping
    *   preprocessing details (optional)
    *   metrics snapshot (optional)

If any one of these is missing, backend inference breaks.

## 2.5 Golden Rule: Feature Alignment

The inference backend assumes:

*   The incoming request contains **raw feature names** exactly as training expected.
*   `metadata["raw_feature_names"]` is the authoritative list.

If you change features in training:

*   you must regenerate `metadata.json`,
*   you must regenerate demo sequences if they were built from old schema,
*   and frontend must use `/features` to remain compatible.

## 2.6 Dataset Label Handling

If label values are strings:

*   keep them as canonical names (BENIGN, DoS, etc.)
*   use `LabelEncoder` and save it.

If label values are numeric:

*   ensure mapping back to human-readable classes exists in metadata.

## 2.7 Sanity Checks Before Delivering Artifacts

Run these:

1.  Load artifacts and predict on a small batch.
2.  Confirm inverse label decoding works.
3.  Confirm probability output dimension matches number of classes.

## 2.8 Performance Targets (Demo)

We care more about:

*   stable inference
*   consistent output
*   fast response for 2 Hz replay

than maximum accuracy.

**
