-- ===================================================
-- Initial Schema - Clinic (PostgreSQL, all English)
-- V1__init_schema.sql
-- ===================================================

-- ENUM for appointment status
CREATE TYPE appointment_status AS ENUM ('BOOKED', 'CONFIRMED', 'COMPLETED', 'CANCELLED');

CREATE TABLE patient (
    id           BIGSERIAL PRIMARY KEY,
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    fiscal_code  VARCHAR(16)  NOT NULL UNIQUE,
    birth_date   DATE         NOT NULL,
    email        VARCHAR(255) NOT NULL,
    phone        VARCHAR(20),
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE doctor (
    id             BIGSERIAL PRIMARY KEY,
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100) NOT NULL,
    specialization VARCHAR(150) NOT NULL,
    email          VARCHAR(255) NOT NULL,
    license_number VARCHAR(50)  NOT NULL UNIQUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE appointment (
    id           BIGSERIAL    PRIMARY KEY,
    patient_id   BIGINT       NOT NULL REFERENCES patient(id) ON DELETE RESTRICT,
    doctor_id    BIGINT       NOT NULL REFERENCES doctor(id)  ON DELETE RESTRICT,
    scheduled_at TIMESTAMP    NOT NULL,
    visit_type   VARCHAR(200) NOT NULL,
    status       appointment_status NOT NULL DEFAULT 'BOOKED',
    notes        TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE report (
    id             BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT    NOT NULL UNIQUE REFERENCES appointment(id) ON DELETE RESTRICT,
    issued_date    DATE      NOT NULL DEFAULT CURRENT_DATE,
    diagnosis      TEXT      NOT NULL,
    prescription   TEXT,
    doctor_notes   TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_doctor  ON appointment(doctor_id);
CREATE INDEX idx_appointment_status  ON appointment(status);
CREATE INDEX idx_appointment_date    ON appointment(scheduled_at);

INSERT INTO doctor (first_name, last_name, specialization, email, license_number) VALUES
    ('Mario',    'Rossi',    'Cardiology',       'mario.rossi@clinicasalute.it',    'RM-12345'),
    ('Laura',    'Bianchi',  'General Medicine', 'laura.bianchi@clinicasalute.it',  'MI-67890'),
    ('Giuseppe', 'Verdi',    'Orthopedics',      'giuseppe.verdi@clinicasalute.it', 'NA-11223'),
    ('Anna',     'Ferrari',  'Neurology',        'anna.ferrari@clinicasalute.it',   'TO-44556'),
    ('Luca',     'Ricci',    'Dermatology',      'luca.ricci@clinicasalute.it',     'FI-77889');

INSERT INTO patient (first_name, last_name, fiscal_code, birth_date, email, phone) VALUES
    ('Carlo',  'Mancini',  'MNCCRL80A01H501Z', '1980-01-01', 'carlo.mancini@email.it',  '3331234567'),
    ('Sofia',  'Greco',    'GRCSFO92B41F839X', '1992-02-01', 'sofia.greco@email.it',    '3449876543'),
    ('Matteo', 'Esposito', 'SPSMT85C10L219K',  '1985-03-10', 'matteo.esposito@email.it','3557654321');

INSERT INTO appointment (patient_id, doctor_id, scheduled_at, visit_type, status) VALUES
    (1, 1, NOW() + INTERVAL '2 days', 'Cardiology Check-up',   'BOOKED'),
    (2, 2, NOW() + INTERVAL '3 days', 'General Medicine Visit', 'CONFIRMED'),
    (3, 3, NOW() - INTERVAL '5 days', 'Orthopedic Visit',       'COMPLETED');

INSERT INTO report (appointment_id, diagnosis, prescription, doctor_notes) VALUES
    (3, 'Right knee tendinitis', 'Complete rest for 2 weeks, ibuprofen 400mg 3 times a day', 'Re-evaluation in 15 days');
