# 3) Backend Developer Documentation (FastAPI + Secure Inference)

## 3.1 Purpose of the Backend

Backend provides:

*   static serving for frontend (`/`, `/static/*`)
*   demo data endpoints (`/demo/manifest`, `/demo/sequence/{name}`)
*   **secure inference endpoint** (`/predict`) with:
    *   preprocessing
    *   XGBoost inference
    *   decoded label output
    *   probabilities
    *   **HMAC-SHA-256 integrity enforcement**

## 3.2 Paper vs What We Implemented (Backend View)

### What the paper proposes

The paper’s framework is a full autonomous IDS pipeline with multi-stage automation (AutoDP/AutoFE/HPO/OCSE). [\[ieee-dataport.org\]](https://ieee-dataport.org/documents/cicids2017)

### What we implemented

A deployable “operational wrapper” around a representative ML core:

*   Single-record inference API
*   Replay-friendly endpoints
*   Cryptographic enforcement (HMAC) to make edge-to-service messaging trustworthy
*   Strict schema control via `/features`

This backend acts like the “policy enforcement and deployment surface” that the paper’s framework conceptually supports, even though we do not run full OCSE + BO-TPE inside the API. [\[ieee-dataport.org\]](https://ieee-dataport.org/documents/cicids2017)

## 3.3 What You Own (Backend Responsibilities)

*   `app.py` (FastAPI server)
*   endpoint contracts
*   artifact loading at startup
*   HMAC verification logic
*   payload canonicalization (must match frontend)

## 3.4 Key Endpoints & Contracts

### Health

*   `GET /health` → model loaded, feature count

### Feature schema

*   `GET /features` → authoritative list of required features
    Frontend must use this to build payload.

### Secure inference

*   `POST /predict`
    *   Request body: `{"features": {...}}`
    *   Required header: `X-Signature: <hex>`

Backend must:

1.  verify signature before inference
2.  filter to required features only
3.  compute prediction + probabilities

### Demo data

*   `GET /demo/manifest`
*   `GET /demo/sequence/{sequence_name}`

## 3.5 HMAC Enforcement: Non-Negotiables

Backend computes:

*   canonical JSON using `json.dumps(payload, sort_keys=True, separators=(",", ":"))`

Frontend must sign the **exact same bytes**.

If you change:

*   separators
*   encoding
*   key sorting
*   header name

…you will break the system.

## 3.6 Common Failure Modes & Debug

### 401 Unauthorized

*   HMAC mismatch:
    *   frontend canonicalization mismatch
    *   wrong secret
    *   modified payload shape

### 400 Missing features

*   request missing required keys:
    *   frontend not using `/features`
    *   demo sequence schema mismatch

### 500 Inference failed

*   artifacts missing
*   joblib load error
*   preprocessing mismatch

## 3.7 Deployment Notes (Local Demo)

For demo, run:

```bash
uvicorn app:app --reload
```

Then:

*   UI: `http://127.0.0.1:8000/`
*   Check: `http://127.0.0.1:8000/health`

## 3.8 Backend Acceptance Tests

✅ `/health` returns model\_loaded true  
✅ `/features` returns expected\_feature\_count > 0  
✅ `/demo/manifest` returns sequences list  
✅ `/demo/sequence/{name}` returns 60 rows  
✅ `/predict` returns 200 for valid signed request  
✅ `/predict` returns 401 for invalid signature  
✅ replay runs continuously with no dropped steps.

***

## Quick “Who Does What” Summary

### Frontend Dev

*   UI/Replay/Chart/Confidence visualization
*   HMAC signing
*   use `/features` to build payload

### Model Trainer Dev

*   Train XGBoost model + preprocessing
*   export artifacts + metadata
*   keep schema stable

### Backend Dev

*   Serve UI and demo sequences
*   verify HMAC
*   run preprocessing + inference

***

If you want, I can also generate:

*   a **one-page “project map”** for all contributors (folder structure + responsibilities),
*   a **runbook** (how to demo end-to-end in 2 minutes),
*   and a **troubleshooting checklist** (common errors and fixes).
