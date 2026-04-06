-- Frontend_Dental_DB – user accounts for the Frontend microservice
CREATE DATABASE IF NOT EXISTS Frontend_Dental_DB;
USE Frontend_Dental_DB;

CREATE TABLE IF NOT EXISTS User (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

-- Sample users (password would be hashed in production)
INSERT IGNORE INTO User (username, password) VALUES ('admin',    'admin123');
INSERT IGNORE INTO User (username, password) VALUES ('ameera',   'pass123');
INSERT IGNORE INTO User (username, password) VALUES ('ali',      'pass123');
INSERT IGNORE INTO User (username, password) VALUES ('patient1', 'pass123');
