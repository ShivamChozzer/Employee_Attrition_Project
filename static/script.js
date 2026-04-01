document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("attritionForm");
    const predictButton = document.getElementById("predictBtn");
    const predictionDisplay = document.getElementById("predictionResult");
    const employeesTableBody = document.getElementById("employeesTableBody"); // Add this for table population

    if (!form) {
        console.error("Form with ID 'attritionForm' not found!");
        return;
    }

    // Fetch and display employee records
    async function fetchEmployees() {
        try {
            const response = await fetch("http://127.0.0.1:5000/employees");
            if (!response.ok) {
                throw new Error(`Error fetching employees: ${response.status}`);
            }

            const employees = await response.json();
            console.log("Fetched Employees:", employees);

            // Clear existing table rows
            employeesTableBody.innerHTML = "";

            // Populate table with employee data
            employees.forEach(employee => {
                const row = document.createElement("tr");

                row.innerHTML = `
                    <td>${employee.id || "-"}</td>
                    <td>${employee.age || "-"}</td>
                    <td>${employee.business_travel || "-"}</td>
                    <td>${employee.department || "-"}</td>
                    <td>${employee.distance || "-"}</td>
                    <td>${employee.education || "-"}</td>
                    <td>${employee.gender || "-"}</td>
                    <td>${employee.job_role || "-"}</td>
                    <td>${employee.marital_status || "-"}</td>
                    <td>${employee.income || "-"}</td>
                    <td>${employee.years || "-"}</td>
                    <td>${employee.prediction === 1 ? "Yes" : "No"}</td>
                `;

                employeesTableBody.appendChild(row);
            });
        } catch (error) {
            console.error("Error fetching employees:", error);
        }
    }

    // Fetch employees on page load
    // fetchEmployees();

    form.addEventListener("submit", async function (event) {
        event.preventDefault();

        predictButton.disabled = true;
        predictButton.textContent = "Processing...";

        const formData = new FormData(form);

        console.log("Form Data Sent:");
        for (let pair of formData.entries()) {
            console.log(`${pair[0]}: ${pair[1]}`);
        }

        try {
            const response = await fetch("http://127.0.0.1:5000/predict", {
                method: "POST",
                body: formData,
            });

            if (!response.ok) {
                const errorText = await response.text();
                console.error("Server response:", errorText);
                throw new Error(`Server error: ${response.status} - ${errorText}`);
            }

            const result = await response.json();
            console.log("Prediction Result:", result);

            if (result.error) {
                alert("Error: " + result.error);
            } else {
                predictionDisplay.innerHTML = `<h3>Prediction: ${result.prediction === 1 ? "Yes (Attrition Likely)" : "No (Attrition Unlikely)"}</h3>`;
                predictionDisplay.style.display = "block";

                setTimeout(() => {
                    window.location.href = "/employees";
                }, 3000);
            }
        } catch (error) {
            console.error("Error:", error);
            alert("Server error. Please check logs.");
        } finally {
            predictButton.disabled = false;
            predictButton.textContent = "Predict";
        }
    });
});
