-- Search_Dental_DB – dentist search microservice database
-- Tables: DENTIST, SPECIALTY, DENTIST_SPECIALTY
CREATE DATABASE IF NOT EXISTS Search_Dental_DB;
USE Search_Dental_DB;

CREATE TABLE IF NOT EXISTS DENTIST (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    clinic VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS SPECIALTY (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS DENTIST_SPECIALTY (
    dentistId   INT,
    specialtyId INT,
    PRIMARY KEY (dentistId, specialtyId),
    FOREIGN KEY (dentistId)   REFERENCES DENTIST(id),
    FOREIGN KEY (specialtyId) REFERENCES SPECIALTY(id)
);

-- Sample specialties
INSERT IGNORE INTO SPECIALTY (id, name) VALUES (1, 'General Dentistry');
INSERT IGNORE INTO SPECIALTY (id, name) VALUES (2, 'Orthodontics');
INSERT IGNORE INTO SPECIALTY (id, name) VALUES (3, 'Oral Surgery');
INSERT IGNORE INTO SPECIALTY (id, name) VALUES (4, 'Pediatric Dentistry');

-- Sample dentists
INSERT IGNORE INTO DENTIST (id, name, clinic) VALUES (1, 'Dr Smith', 'Downtown Dental');
INSERT IGNORE INTO DENTIST (id, name, clinic) VALUES (2, 'Dr Lee',   'Smile Clinic');
INSERT IGNORE INTO DENTIST (id, name, clinic) VALUES (3, 'Dr Jones', 'Family Dentistry');
INSERT IGNORE INTO DENTIST (id, name, clinic) VALUES (4, 'Dr Patel', 'City Orthodontics');

-- Assign specialties
INSERT IGNORE INTO DENTIST_SPECIALTY VALUES (1, 1); -- Dr Smith – General
INSERT IGNORE INTO DENTIST_SPECIALTY VALUES (2, 1); -- Dr Lee   – General
INSERT IGNORE INTO DENTIST_SPECIALTY VALUES (3, 4); -- Dr Jones – Pediatric
INSERT IGNORE INTO DENTIST_SPECIALTY VALUES (4, 2); -- Dr Patel – Orthodontics
