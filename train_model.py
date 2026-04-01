import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.tree import DecisionTreeClassifier

# Load cleaned dataset
df = pd.read_csv("WA_Fn-UseC_-HR-Employee-Attrition.csv")

# Encode categorical columns
label_encoders = {}
categorical_cols = ["BusinessTravel", "Department", "Gender", "JobRole", "MaritalStatus"]

for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    label_encoders[col] = le

# Define features (X) and target (y)
X = df.drop(columns=["prediction"])  # Keep only feature columns
y = df["prediction"]  # Target variable (Attrition: 0 or 1)

# Split dataset into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train ML model (Decision Tree Classifier)
model = DecisionTreeClassifier(random_state=42)
model.fit(X_train, y_train)

# Save the trained model and label encoders
joblib.dump(model, "attrition_model.pkl")
joblib.dump(label_encoders, "label_encoders.pkl")

print("✅ Model training complete! Files saved as attrition_model.pkl and label_encoders.pkl")
