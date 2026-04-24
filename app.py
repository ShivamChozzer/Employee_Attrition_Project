from flask import Flask, render_template, request, jsonify
import pymysql
import numpy as np
from flask_cors import CORS
import joblib
import os

try:
    from dotenv import load_dotenv
except Exception:
    load_dotenv = None

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# MySQL Database Connection
def get_db_connection():
    if load_dotenv is not None:
        load_dotenv()

    try:
        db = pymysql.connect(
            host=os.getenv("DB_HOST", "127.0.0.1"),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", ""),
            database=os.getenv("DB_NAME", "employee_attrition"),
            cursorclass=pymysql.cursors.DictCursor
        )
        return db
    except Exception as e:
        print("❌ Database connection failed:", str(e))
        return None

# Load ML model and label encoders
try:
    model = joblib.load("attrition_model.pkl")
    label_encoders = joblib.load("label_encoders.pkl")
    print("✅ Model and Label Encoders loaded successfully.")
except Exception as e:
    print("❌ Error loading model:", str(e))
    model = None

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/predict", methods=["POST"])
def predict():
    db = None
    try:
        db = get_db_connection()
        if not db:
            return jsonify({"error": "Database connection failed"}), 500

        if model is None:
            return jsonify({"error": "Model is not loaded"}), 500

        form_data = request.form
        if not form_data:
            return jsonify({"error": "No form data received"}), 400

        print("Received Data:", form_data)  # Debugging

        # Extract and validate form data
        try:
            raw_values = {
                "Age": int(form_data.get("Age", 0)),
                "BusinessTravel": form_data.get("BusinessTravel", ""),
                "Department": form_data.get("Department", ""),
                "DistanceFromHome": int(form_data.get("DistanceFromHome", 0)),
                "Education": int(form_data.get("Education", 0)),
                "Gender": form_data.get("Gender", ""),
                "JobRole": form_data.get("JobRole", ""),
                "MaritalStatus": form_data.get("MaritalStatus", ""),
                "MonthlyIncome": int(form_data.get("MonthlyIncome", 0)),
                "YearsAtCompany": int(form_data.get("YearsAtCompany", 0)),
            }
        except ValueError as e:
            return jsonify({"error": f"Invalid data type: {str(e)}"}), 400

        # Encode categorical values
        encoded_values = []
        for key, value in raw_values.items():
            if key in label_encoders:
                if value not in label_encoders[key].classes_:
                    return jsonify({"error": f"Invalid value '{value}' for {key}"}), 400
                encoded_values.append(int(label_encoders[key].transform([value])[0]))
            else:
                encoded_values.append(value)

        # Convert to NumPy array
        final_values = np.array(encoded_values, dtype=np.float32).reshape(1, -1)

        # Ensure model supports prediction
        if hasattr(model, "predict"):
            prediction = model.predict(final_values)[0]
        else:
            return jsonify({"error": "Model does not support prediction"}), 500

        # Insert prediction into database
        try:
            with db.cursor() as cursor:
                sql = """
                    INSERT INTO employees 
                    (Age, BusinessTravel, Department, DistanceFromHome, Education, 
                    Gender, JobRole, MaritalStatus, MonthlyIncome, YearsAtCompany, prediction)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (
                    raw_values["Age"], raw_values["BusinessTravel"], raw_values["Department"],
                    raw_values["DistanceFromHome"], raw_values["Education"], raw_values["Gender"],
                    raw_values["JobRole"], raw_values["MaritalStatus"], raw_values["MonthlyIncome"],
                    raw_values["YearsAtCompany"], int(prediction)
                ))
                db.commit()
        except pymysql.MySQLError as e:
            return jsonify({"error": f"Database error: {str(e)}"}), 500

        return jsonify({
            "prediction": int(prediction),
            "message": "Prediction successful"
        })

    except Exception as e:
        print("❌ Error in predict():", str(e))
        return jsonify({"error": str(e)}), 500
    finally:
        if db:
            db.close()
            
@app.route('/employees')
def get_employees():
    db = None
    try:
        db = get_db_connection()
        if db is None:
            return jsonify({"error": "Database connection failed"}), 500

        with db.cursor() as cursor:
            query = "SELECT * FROM employees"
            cursor.execute(query)
            data = cursor.fetchall()

            print("Fetched Data:", data)  # Debugging

            return render_template("employees.html", employees=data)  # Render HTML template

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        if db:
            db.close()

if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    app.run(host="0.0.0.0", port=port, debug=os.getenv("FLASK_DEBUG", "0") == "1")
