
***

# 1) Frontend Developer Documentation (Replay Dashboard + Visualization)

## 1.1 Purpose of the Frontend

The frontend is a **local replay dashboard** that demonstrates:

*   how traffic evolves from **BENIGN → mixed → attack-dominant** over a 30-second window,
*   how the ML model’s predictions evolve over time,
*   and how **confidence** can be visualized (HUD), optionally.

This is a **demo-oriented UI**, not a full production console.

## 1.2 Paper vs What We Implemented (Frontend View)

### What the paper proposes

The paper proposes an **AutoML-driven autonomous IDS** that automates the full ML pipeline: data balancing (TVAE), feature engineering, model selection, hyperparameter optimization (BO-TPE), and ensembling (OCSE). [\[ieee-dataport.org\]](https://ieee-dataport.org/documents/cicids2017)

### What we implemented

We implemented a **lightweight demonstrator**:

*   A **replay timeline** (Option 3) + **feature trend overlay** (Option 4) + **confidence HUD** (Option 5),
*   A FastAPI backend that performs **single-record inference**,
*   Secure inference calls using **HMAC-SHA-256** authentication (cryptographic integrity enforcement).

This is meant to illustrate how such systems can be used in **edge/IoT contexts**, where patterns are not obvious to humans.

## 1.3 What You Own (Frontend Responsibilities)

You own the following:

*   `templates/index.html` (page structure)
*   `static/styles.css` (UI styling)
*   `static/app.js` (replay engine + charts + API calls + HMAC signing)

Your frontend:

1.  Fetches available sequences from `/demo/manifest`
2.  Loads a selected sequence from `/demo/sequence/{sequence_name}`
3.  Replays rows at **2 Hz** (every 500ms)
4.  For each row:
    *   Builds payload with only expected feature keys (`/features`)
    *   Signs payload with **HMAC-SHA-256**
    *   Calls `/predict` with `X-Signature` header
5.  Updates chart + status + confidence view.

## 1.4 Local Setup & Run

### Requirements

*   Backend running at: `http://127.0.0.1:8000`
*   Frontend served by backend via `/` route.

### Start backend

```bash
uvicorn app:app --reload
```

### Open UI

*   Go to: `http://127.0.0.1:8000/`

## 1.5 Critical Integration Contracts (Do Not Break)

### API endpoints

*   `GET /demo/manifest` → list of sequences
*   `GET /demo/sequence/{sequence_name}` → rows (60 rows typically)
*   `GET /features` → exact model feature names
*   `POST /predict` → expects:
    *   JSON body: `{"features": {...}}`
    *   header: `X-Signature: <hex hmac>`

### HMAC Contract (Very Important)

Backend verifies HMAC over **canonical JSON** (sorted keys, compact separators).  
Frontend must sign the **exact same canonical string**.

**Rule**: any change to payload formatting breaks authentication.

## 1.6 Replay Sequence Format Expectations

Each CSV row may include extra columns:

*   `phase`, `phase_label`, `intended_class`, `timestamp_s`, etc.

Frontend must:

*   **ignore extra keys**
*   send only keys provided by `/features`.

## 1.7 Charting Responsibilities

We currently visualize:

*   normalized feature curves (user-selected)
*   prediction overlay (faded)
*   playback cursor (thin vertical line)

If you modify the chart:

*   do not remove axis IDs (`yFeatures`, `yClass`)
*   keep update frequency stable (2 Hz)
*   do not block the UI thread with heavy rendering.

## 1.8 Acceptance Tests (Frontend)

✅ Dropdown populates sequence names  
✅ Load → chart initializes without errors  
✅ Play → inference calls happen at 2 Hz  
✅ No 401 errors (HMAC must pass)  
✅ Confidence HUD updates when probabilities returned  
✅ Reset clears prediction overlay and restarts cursor.

***
