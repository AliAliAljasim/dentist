-- Appointment_Dental_DB – appointment & billing microservice database
-- Tables: APPOINTMENT, BILLING
CREATE DATABASE IF NOT EXISTS Appointment_Dental_DB;
USE Appointment_Dental_DB;

CREATE TABLE IF NOT EXISTS APPOINTMENT (
    appointmentId INT AUTO_INCREMENT PRIMARY KEY,
    userId        INT         NOT NULL,
    dentistId     INT         NOT NULL DEFAULT 0,
    date          VARCHAR(20),
    time          VARCHAR(20),
    service       VARCHAR(100),
    amount        DOUBLE      NOT NULL DEFAULT 100.00
);

CREATE TABLE IF NOT EXISTS BILLING (
    billingId     INT AUTO_INCREMENT PRIMARY KEY,
    appointmentId INT     NOT NULL,
    amount        DOUBLE  NOT NULL DEFAULT 100.00,
    FOREIGN KEY (appointmentId) REFERENCES APPOINTMENT(appointmentId)
);

-- Sample data
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (1, 1, 1, '2026-03-20', '10:00', 'Cleaning', 80.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (2, 1, 2, '2026-03-21', '14:00', 'X-Ray', 120.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (3, 2, 1, '2026-03-22', '09:00', 'Filling', 150.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (4, 1, 3, '2026-03-24', '11:30', 'Checkup', 50.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (5, 1, 2, '2026-03-27', '15:00', 'Cleaning', 80.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (6, 3, 4, '2026-03-28', '13:15', 'Whitening', 300.00);
INSERT IGNORE INTO APPOINTMENT (appointmentId, userId, dentistId, date, time, service, amount)
    VALUES (7, 1, 1, '2026-03-30', '08:45', 'X-Ray', 150.00);

INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (1, 1, 80.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (2, 2, 120.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (3, 3, 150.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (4, 4, 50.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (5, 5, 80.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (6, 6, 300.00);
INSERT IGNORE INTO BILLING (billingId, appointmentId, amount) VALUES (7, 7, 150.00);
