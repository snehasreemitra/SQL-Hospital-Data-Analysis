DROP TABLE IF EXISTS Hospital_Data;

CREATE TABLE Hospital_Data(
    hospital_name VARCHAR(100),
    location VARCHAR(50),
    department VARCHAR(50),
    doctors_count INT,
    patients_count INT,
    admission_date DATE,
    discharge_date DATE,
    medical_expenses NUMERIC(12,2)
);

DROP TABLE IF EXISTS hospital_data_staging;

CREATE TABLE hospital_data_staging (
    hospital_name VARCHAR(100),
    location VARCHAR(50),
    department VARCHAR(50),
    doctors_count INT,
    patients_count INT,
    admission_date TEXT,   -- keep as text first
    discharge_date TEXT,   -- keep as text first
    medical_expenses NUMERIC(12,2)
);

INSERT INTO hospital_data
SELECT
    hospital_name,
    location,
    department,
    doctors_count,
    patients_count,
    TO_DATE(admission_date, 'DD-MM-YYYY'),
    TO_DATE(discharge_date, 'DD-MM-YYYY'),
    medical_expenses
FROM hospital_data_staging;

SELECT * FROM hospital_data_staging;

--1Q
SELECT 
	hospital_name, 
	SUM(patients_count) AS total_patients
FROM hospital_data_staging 
GROUP BY hospital_name ORDER BY total_patients DESC 
LIMIT 1;

--2Q
SELECT 
	hospital_name, 
	AVG(doctors_count) AS total_doctors 
FROM hospital_data_staging 
GROUP BY hospital_name;

--3Q
SELECT 
	department, 
	SUM(patients_count) AS total_patients
FROM hospital_data_staging 
GROUP BY department
ORDER BY total_patients DESC 
LIMIT 3;

--4Q
SELECT 
	hospital_name, 
	MAX(medical_expenses) AS highest_expense
FROM hospital_data_staging 
GROUP BY hospital_name
ORDER BY highest_expense DESC 
LIMIT 1;

--5Q
SELECT 
    hospital_name,
    AVG(medical_expenses / NULLIF((TO_DATE(discharge_date, 'DD-MM-YYYY') - TO_DATE(admission_date, 'DD-MM-YYYY')), 0)) 
        AS avg_expense_per_day
FROM hospital_data_staging
GROUP BY hospital_name;

--6Q
SELECT 
    hospital_name,
    department,
    admission_date,
    discharge_date,
    (TO_DATE(discharge_Date, 'DD-MM-YYYY') - TO_DATE(admission_Date, 'DD-MM-YYYY')) AS stay_length
FROM hospital_data_staging
ORDER BY stay_length DESC
LIMIT 1;

--7Q
SELECT 
    location,
    SUM(patients_count) AS total_patients
FROM hospital_data_staging
GROUP BY location
ORDER BY total_patients DESC;

--8Q
SELECT 
    department,
    AVG(TO_DATE(discharge_Date, 'DD-MM-YYYY') - TO_DATE(admission_date, 'DD-MM-YYYY')) AS avg_stay_days
FROM hospital_data_staging
GROUP BY department
ORDER BY avg_stay_days DESC;

--9Q
SELECT 
    department,
    SUM(patients_count) AS total_patients
FROM hospital_data_staging
GROUP BY department
ORDER BY total_patients ASC
LIMIT 1;

--10Q
SELECT 
    TO_CHAR(TO_DATE(admission_date, 'DD-MM-YYYY'), 'YYYY-MM') AS month,
    SUM(medical_expenses) AS total_expenses
FROM hospital_data_staging
GROUP BY TO_CHAR(TO_DATE(admission_date, 'DD-MM-YYYY'), 'YYYY-MM')
ORDER BY month;







