use employee_attrition;
select*from employees;
drop table employees;
CREATE DATABASE IF NOT EXISTS employee_attrition;
USE employee_attrition;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Age INT NOT NULL,
    BusinessTravel VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    DistanceFromHome INT NOT NULL,
    Education INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    JobRole VARCHAR(50) NOT NULL,
    MaritalStatus VARCHAR(20) NOT NULL,
    MonthlyIncome INT NOT NULL,
    YearsAtCompany INT NOT NULL,
    prediction INT NOT NULL -- 0 (No Attrition) or 1 (Attrition)
);

SELECT * FROM employees;
