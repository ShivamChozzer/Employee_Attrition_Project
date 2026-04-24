# GitHub Pages Demo (How it works)

This repo contains **two ways** to run the Employee Attrition predictor:

- **1) Full Flask app (Python backend)**: `app.py` + `templates/` + `static/`
- **2) GitHub Pages demo (static site)**: `index.html` + `app.js` + `model.json` + `encoders.json` + `style.css`

The GitHub Pages demo exists because **GitHub Pages cannot run Python/Flask or a database**. It can only host static files (HTML/CSS/JS), so the prediction has to run **inside the browser**.

---

## Purpose of the GitHub Pages page

- **Goal**: When someone clicks the GitHub Pages link, they can fill a form and get an attrition prediction immediately.
- **No backend**: No Flask server runs on GitHub Pages.
- **No database**: No MySQL connection is used. Nothing is stored.
- **Good for**: Portfolio/demo link that “just works” from a browser.

---

## What we used

### Backend (full app)

- **Flask**: web server and routes (`/`, `/predict`, `/employees`)
- **Jinja templates**: HTML pages in `templates/`
- **PyMySQL**: optional DB persistence for storing predictions
- **joblib + scikit-learn**: loading and using the trained model (`attrition_model.pkl`)
- **NumPy**: formatting feature vector for prediction

### GitHub Pages (static demo)

- **HTML/CSS**: UI at `index.html` + `style.css`
- **JavaScript**: prediction logic at `app.js`
- **Exported model**: `model.json`
- **Exported encoders**: `encoders.json`

---

## How predictions work on GitHub Pages (browser-only)

### 1) User fills the form

The form collects the same 10 features used by the model (in this order):

1. `Age`
2. `BusinessTravel`
3. `Department`
4. `DistanceFromHome`
5. `Education`
6. `Gender`
7. `JobRole`
8. `MaritalStatus`
9. `MonthlyIncome`
10. `YearsAtCompany`

### 2) Categorical values are label-encoded (in JS)

In training, categorical features were converted to integers using `LabelEncoder`.

For the demo, we export those encoder “classes” into `encoders.json`, for example:

- `BusinessTravel`: `["Non-Travel", "Travel_Frequently", "Travel_Rarely"]`

In `app.js`, when a user selects `"Travel_Rarely"`, we convert it to its index `2`.

### 3) DecisionTree is evaluated in JavaScript

The trained `DecisionTreeClassifier` is exported into `model.json` using:

- `children_left`, `children_right`
- `feature`, `threshold`
- leaf `value` (class probabilities)

Then `app.js` traverses the tree:

- Start at node `0`
- If it’s an internal node, compare `x[feature] <= threshold`
- Go left or right
- If it’s a leaf (`feature == -2`), choose the class with highest probability

### 4) Output shown in the page

- **Class = 0** → “No attrition likely”
- **Class = 1** → “Attrition likely”

---

## Why the database page/link is removed on GitHub Pages

The original Flask app has an `/employees` page that reads stored rows from MySQL.

On GitHub Pages:

- there is **no server** to query
- there is **no MySQL** connection

So the static demo intentionally only supports **predicting** (not listing/storing employees).

---

## How to deploy GitHub Pages for this repo

In GitHub:

- Repo → **Settings** → **Pages**
- **Source**: Deploy from a branch
- **Branch**: `main`
- **Folder**: `/ (root)`

The live page is served from the repo root `index.html`.

---

## If you want the full app hosted publicly (with optional DB)

Use a host that can run Python (Render/Railway/Fly.io/etc). That deployment runs:

- `gunicorn app:app` (see `Procfile`)
- dependencies from `requirements.txt`

DB persistence is optional; if DB env vars aren’t provided, you can still run predictions.

