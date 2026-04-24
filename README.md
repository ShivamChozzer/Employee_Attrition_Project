# Employee Attrition Prediction System

This project is a **Flask + MySQL** web app that predicts employee attrition using a trained ML model and stores predictions in a database.

## GitHub Pages (project landing page)

GitHub Pages can only host static files, so this repo includes a static landing page in `docs/`.

## Run locally

- **1) Create the database**
  - Run `database_setup.sql` in MySQL.

- **2) Configure environment variables**
  - Copy `.env.example` to `.env` and set values (or export env vars in your shell):
    - `DB_HOST`
    - `DB_USER`
    - `DB_PASSWORD`
    - `DB_NAME`

- **3) Install dependencies**
  - Install Python packages used by the app (`flask`, `pymysql`, `numpy`, `joblib`, `flask-cors`, etc.).

- **4) Start the server**
  - `python app.py`
  - Open `http://127.0.0.1:5000`

