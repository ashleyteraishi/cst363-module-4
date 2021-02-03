-- create the database
DROP DATABASE IF EXISTS healthcare;
CREATE DATABASE healthcare;

-- select the database
USE healthcare;

-- create tables and data
CREATE TABLE address
(	address_id INT NOT NULL,
	address1 VARCHAR(100) NOT NULL,
	address2 VARCHAR(15),
	city VARCHAR(25) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code NUMERIC(5, 0) NOT NULL,
    PRIMARY KEY (address_id)
);

CREATE TABLE patient
(	SSN NUMERIC(9, 0) NOT NULL,
	first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    dob DATE NOT NULL,
    age INT,
    address_id INT NOT NULL,
    PRIMARY KEY (SSN),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE doctor
(	SSN NUMERIC(9, 0) NOT NULL,
	first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    specialty VARCHAR(25) NOT NULL,
    start_date DATE NOT NULL,
    years_experience INT,
    PRIMARY KEY (SSN)
);

CREATE TABLE treats 
(	dr_ssn NUMERIC(9, 0) REFERENCES doctor(SSN),
	patient_ssn NUMERIC(9, 0) REFERENCES patient(SSN),
    PRIMARY KEY (dr_ssn, patient_ssn)
);

CREATE TABLE pharmacy
(	pharma_id INT NOT NULL,
	pharma_name VARCHAR(25) NOT NULL,
    pharma_phone VARCHAR(15) NOT NULL,
    address_id INT NOT NULL,
    PRIMARY KEY (pharma_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE pharma_co
(	pharma_co_name VARCHAR(40) NOT NULL,
	pharma_co_phone VARCHAR(15) NOT NULL,
    PRIMARY KEY (pharma_co_name)
);

CREATE TABLE contract 
(	contract_id INT NOT NULL,
	start_date DATE NOT NULL,
    end_date DATE,
    text VARCHAR(100) NOT NULL,
    pharma_id INT NOT NULL,
    pharma_co_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (contract_id),
    FOREIGN KEY (pharma_id) REFERENCES pharmacy(pharma_id),
    FOREIGN KEY (pharma_co_name) REFERENCES pharma_co(pharma_co_name)
);

CREATE TABLE supervises
(	pharma_id INT REFERENCES pharmacy(pharma_id),
	contract_id INT REFERENCES contract(contract_id),
    supervisor VARCHAR(25) NOT NULL,
    PRIMARY KEY (pharma_id, contract_id)
);

CREATE TABLE drug
(	trade_name VARCHAR(25) NOT NULL,
	formula VARCHAR(50) NOT NULL,
	pharma_co_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (trade_name),
    FOREIGN KEY (pharma_co_name) REFERENCES pharma_co(pharma_co_name) ON DELETE CASCADE
);

CREATE TABLE sells
(	price NUMERIC(4, 2) NOT NULL CHECK (price > 0),
	pharma_id INT REFERENCES pharmacy(pharma_id),
	trade_name VARCHAR(25) REFERENCES drug(trade_name),
    PRIMARY KEY (pharma_id, trade_name)
);

CREATE TABLE prescription
(	prescription_id INT NOT NULL AUTO_INCREMENT,
	quantity INT,
    prescribe_date DATE,
    fill_date DATE,
    pharma_id INT,
    dr_ssn NUMERIC(9, 0) NOT NULL,
    patient_ssn NUMERIC(9, 0) NOT NULL,
    trade_name VARCHAR(25) NOT NULL,
    PRIMARY KEY (prescription_id),
    FOREIGN KEY (pharma_id) REFERENCES pharmacy(pharma_id),
    FOREIGN KEY (dr_ssn) REFERENCES doctor(SSN),
    FOREIGN KEY (patient_ssn) REFERENCES patient(SSN),
    FOREIGN KEY (trade_name) REFERENCES drug(trade_name)
);

-- insert values into healthcare tables
INSERT INTO address VALUES (101, '123 Street Ave', null, 'Los Angeles', 'CA', 90210);
INSERT INTO address VALUES (102, '111 Pharma St', null, 'Los Angeles', 'CA', 90210);
INSERT INTO address VALUES (103, '222 Park St', 'Apt 3', 'Torrance', 'CA', 90505);
INSERT INTO address VALUES (104, '333 Pharma Blvd', null, 'Torrance', 'CA', 90505);
INSERT INTO address VALUES (105, '444 Main St', 'Apt A', 'Los Angeles', 'CA', 90211); 
INSERT INTO address VALUES (106, '555 Sick Way', 'Suite 105', 'Los Angeles', 'CA', 90211);

INSERT INTO patient VALUES (123456789, 'Jane', 'Doe', '1997-09-17', null, 101);
INSERT INTO patient VALUES (987654321, 'John', 'Doe', '1990-05-01', null, 103);
INSERT INTO patient VALUES (112233445, 'Tim', 'Smith', '1980-06-11', null, 105);

INSERT INTO doctor VALUES (567894321, 'James', 'Doctor', 'General', '2000-01-24', null);
INSERT INTO doctor VALUES (654321987, 'Jamie', 'Stomach', 'Gastroenterology', '2001-01-24', null);
INSERT INTO doctor VALUES (963852741, 'Robert', 'Park', 'General', '2005-02-14', null);
INSERT INTO doctor VALUES (846153279, 'Jack', 'Carson', 'Psychiatry', '1999-05-16', null);

INSERT INTO treats VALUES(567894321, 123456789);
INSERT INTO treats VALUES(654321987, 987654321);
INSERT INTO treats VALUES(567894321, 987654321);
INSERT INTO treats VALUES(963852741, 112233445);
INSERT INTO treats VALUES(846153279, 112233445);

INSERT INTO pharmacy VALUES (201, 'CVS', '123-456-7890', 102);
INSERT INTO pharmacy VALUES (202, 'CVS', '987-654-3210', 104);
INSERT INTO pharmacy VALUES (203, 'Rite-Aid', '963-852-7410', 106);

INSERT INTO pharma_co VALUES ('Pfizer', '102-345-6789');
INSERT INTO pharma_co VALUES ('3M Pharmaceuticals', '111-222-3333');
INSERT INTO pharma_co VALUES ('Bayer', '741-852-0369');
INSERT INTO pharma_co VALUES ('Moderna', '852-369-0147');
INSERT INTO pharma_co VALUES ('Inovio', '123-654-7809');
INSERT INTO pharma_co VALUES ('Novartis', '254-631-7890'); 

INSERT INTO contract VALUES (301, '2021-01-20', '2025-01-20', 'This is the text of the contract', 201, 'Pfizer');
INSERT INTO contract VALUES (302, '2021-01-21', '2025-01-21', 'Text of contract goes here', 202, '3M Pharmaceuticals');
INSERT INTO contract VALUES (303, '2021-01-22', '2030-01-22', 'Contract text example', 202, 'Pfizer');
INSERT INTO contract VALUES (304, '2021-01-23', '2022-01-23', 'Contract text', 203, 'Bayer');
INSERT INTO contract VALUES (305, '2021-01-23', '2025-01-23', 'This is the text of the contract', 201, 'Bayer');
INSERT INTO contract VALUES (306, '2021-01-24', '2024-01-24', 'Contract text', 203, 'Pfizer');
INSERT INTO contract VALUES (307, '2021-01-24', '2030-01-24', 'Contract text', 202, 'Moderna');
INSERT INTO contract VALUES (308, '2021-01-24', '2024-01-24', 'Contract text', 203, 'Moderna');
INSERT INTO contract VALUES (309, '2021-01-25', '2022-01-25', 'Contract text', 201, 'Novartis');
INSERT INTO contract VALUES (310, '2021-01-25', '2023-01-25', 'Contract text', 203, 'Novartis');
INSERT INTO contract VALUES (311, '2021-01-25', '2025-01-25', 'Contract text',  201, 'Inovio');
INSERT INTO contract VALUES (312, '2021-01-25', '2030-01-25', 'Contract text', 202, 'Inovio');

INSERT INTO supervises VALUES (201, 301, 'Macy Newson');
INSERT INTO supervises VALUES (202, 302, 'Jack Smith');
INSERT INTO supervises VALUES (202, 303, 'Jimmy Dean');
INSERT INTO supervises VALUES (203, 304, 'Boss Man');
INSERT INTO supervises VALUES (201, 305, 'Jim John');
INSERT INTO supervises VALUES (203, 306, 'Fred Johnson');
INSERT INTO supervises VALUES (202, 307, 'Susy Lee');
INSERT INTO supervises VALUES (203, 308, 'Supervisor');
INSERT INTO supervises VALUES (201, 309, 'Edward Son');
INSERT INTO supervises VALUES (203, 310, 'Jack Wilson');
INSERT INTO supervises VALUES (201, 311, 'Mary Sue');
INSERT INTO supervises VALUES (202, 312, 'Dean John');

INSERT INTO drug VALUES ('Advil', 'Ibuprofen', 'Pfizer');
INSERT INTO drug VALUES ('Tylenol', 'Acetaminophen', 'Inovio');
INSERT INTO drug VALUES ('Aspirin', 'Formula', 'Bayer');
INSERT INTO drug VALUES ('Reglan', 'Metoclopramide', '3M Pharmaceuticals');
INSERT INTO drug VALUES ('Zoloft', 'Setraline', 'Moderna');
INSERT INTO drug VALUES ('Xanax', 'Alprazolam', 'Novartis');

INSERT INTO sells VALUES (5.00, 201, 'Advil');
INSERT INTO sells VALUES (4.50, 202, 'Advil');
INSERT INTO sells VALUES (3.50, 201, 'Tylenol');
INSERT INTO sells VALUES (4.00, 202, 'Tylenol');
INSERT INTO sells VALUES (5.00, 201, 'Aspirin');
INSERT INTO sells VALUES (4.50, 203, 'Aspirin');
INSERT INTO sells VALUES (4.50, 202, 'Reglan');
INSERT INTO sells VALUES (10.00, 202, 'Zoloft');
INSERT INTO sells VALUES (12.00, 203, 'Zoloft');
INSERT INTO sells VALUES (9.50, 201, 'Xanax');
INSERT INTO sells VALUES (10.00, 203, 'Xanax');
INSERT INTO sells VALUES (2.50, 203, 'Advil');

INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	VALUES (5, '2021-01-20', '2021-01-24', 201, 567894321, 123456789, 'Advil');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	VALUES (30, '2021-01-21', '2021-01-21', 201, 654321987, 987654321, 'Reglan');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	VALUES (15, '2021-01-22', '2021-01-23', 202, 567894321, 987654321, 'Aspirin');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (10, '2021-01-24', '2021-01-24', 202, 567894321, 123456789, 'Tylenol');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (20, '2021-01-24', '2021-01-24', 203, 963852741, 112233445, 'Zoloft');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (10, '2021-01-24', '2021-01-25', 203, 846153279, 112233445, 'Advil');
-- duplicate prescriptions 
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (10, '2021-01-24', '2021-01-25', 203, 846153279, 112233445, 'Advil');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (10, '2021-01-24', '2021-01-25', 203, 846153279, 112233445, 'Advil');
INSERT INTO prescription (quantity, prescribe_date, fill_date, pharma_id, dr_ssn, patient_ssn, trade_name)
	 VALUES (10, '2021-01-24', '2021-01-25', 203, 846153279, 112233445, 'Advil');

-- add derived attributes
UPDATE patient
SET age = (SELECT (FLOOR(DATEDIFF(SYSDATE(), dob) / 365)));
    
UPDATE doctor
SET years_experience = (SELECT (FLOOR(DATEDIFF(SYSDATE(), start_date) / 365)));

-- delete duplicate prescriptions (same doctor, patient, drug)
DELETE p1 FROM prescription p1
INNER JOIN prescription p2
WHERE p1.prescription_id < p2.prescription_id
AND p1.dr_ssn = p2.dr_ssn
AND p1.patient_ssn = p2.patient_ssn
AND p1.trade_name = p2.trade_name;


-- QUESTIONS

--  Question 1 - How many times has each drug been prescribed?
SELECT drug.trade_name, COUNT(prescription_id)
FROM drug
LEFT JOIN prescription
ON drug.trade_name = prescription.trade_name
GROUP BY prescription.trade_name;

-- Question 2 - Which pharmacy has Advil for the lowest price?
SELECT pharmacy.pharma_id, pharmacy.pharma_name, sells.price, sells.trade_name
FROM pharmacy
JOIN drug
JOIN sells
ON drug.trade_name = sells.trade_name
AND pharmacy.pharma_id = sells.pharma_id
GROUP BY sells.pharma_id
HAVING sells.price = MIN(sells.price)
AND sells.trade_name = 'Advil';

-- Question 3 - Who are the supervisors for the contracts between Pfizer and CVS, 
-- what are the start and end dates of the contracts?
SELECT contract.pharma_co_name, contract.pharma_id, pharmacy.pharma_name, 
	supervises.supervisor, contract.start_date, contract.end_date
FROM pharmacy
JOIN pharma_co
JOIN contract
ON pharmacy.pharma_id = contract.pharma_id
AND pharma_co.pharma_co_name = contract.pharma_co_name
JOIN supervises
ON pharmacy.pharma_id = supervises.pharma_id
AND contract.contract_id = supervises.contract_id
WHERE pharmacy.pharma_name = 'CVS'
GROUP BY contract.contract_id
HAVING contract.pharma_co_name = 'Pfizer';

-- Question 4 - Which drugs does Pfizer sell and to which pharmacies does it sell them to?
SELECT pharma_co.pharma_co_name, drug.trade_name, pharmacy.pharma_id, pharmacy.pharma_name
FROM pharma_co
JOIN drug
ON pharma_co.pharma_co_name = drug.pharma_co_name
JOIN pharmacy
JOIN sells
ON pharmacy.pharma_id = sells.pharma_id
AND drug.trade_name = sells.trade_name
WHERE pharma_co.pharma_co_name = 'Pfizer'
GROUP BY pharmacy.pharma_id;

-- Question 5 - Find Tim Smith's doctor(s) by his name (not SSN), any prescriptions from the doctor(s), 
-- the drug(s) prescribed, the quantity, and where the prescription was filled
SELECT CONCAT(patient.first_name, ' ', patient.last_name) AS patient_name, 
	CONCAT(doctor.first_name, ' ', doctor.last_name) AS dr_name,
	drug.trade_name, prescription.quantity, prescription.pharma_id, 
    pharmacy.pharma_name, prescription.fill_date
FROM patient
JOIN doctor
JOIN treats
ON patient.SSN = treats.patient_ssn
AND doctor.SSN = treats.dr_ssn
JOIN pharmacy
JOIN drug
JOIN prescription
ON pharmacy.pharma_id = prescription.pharma_id
AND drug.trade_name = prescription.trade_name
AND patient.SSN = prescription.patient_ssn
AND doctor.SSN = prescription.dr_ssn
WHERE CONCAT(patient.first_name, ' ', patient.last_name) = 'Tim Smith'
GROUP BY prescription.prescription_id, doctor.SSN;


