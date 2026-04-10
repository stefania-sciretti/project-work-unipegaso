-- ===================================================
-- Initial Schema - Clinic (H2-compatible, all English)
-- ===================================================

CREATE TABLE IF NOT EXISTS patient (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    fiscal_code  VARCHAR(16)  NOT NULL UNIQUE,
    birth_date   DATE         NOT NULL,
    email        VARCHAR(255) NOT NULL,
    phone        VARCHAR(20),
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS doctor (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100) NOT NULL,
    specialization VARCHAR(150) NOT NULL,
    email          VARCHAR(255) NOT NULL,
    license_number VARCHAR(50)  NOT NULL UNIQUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS appointment (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id   BIGINT       NOT NULL REFERENCES patient(id),
    doctor_id    BIGINT       NOT NULL REFERENCES doctor(id),
    scheduled_at TIMESTAMP    NOT NULL,
    visit_type   VARCHAR(200) NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'BOOKED',
    notes        TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS report (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id BIGINT    NOT NULL UNIQUE REFERENCES appointment(id),
    issued_date    DATE      NOT NULL DEFAULT CURRENT_DATE,
    diagnosis      TEXT      NOT NULL,
    prescription   TEXT,
    doctor_notes   TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO doctor (first_name, last_name, specialization, email, license_number) VALUES
    ('Mario',    'Rossi',    'Cardiology',        'mario.rossi@clinicasalute.it',    'RM-12345'),
    ('Laura',    'Bianchi',  'General Medicine',  'laura.bianchi@clinicasalute.it',  'MI-67890'),
    ('Giuseppe', 'Verdi',    'Orthopedics',       'giuseppe.verdi@clinicasalute.it', 'NA-11223');

INSERT INTO patient (first_name, last_name, fiscal_code, birth_date, email, phone) VALUES
    ('Carlo',  'Mancini',  'MNCCRL80A01H501Z', '1980-01-01', 'carlo.mancini@email.it',  '3331234567'),
    ('Sofia',  'Greco',    'GRCSFO92B41F839X', '1992-02-01', 'sofia.greco@email.it',    '3449876543'),
    ('Matteo', 'Esposito', 'SPSMT85C10L219K',  '1985-03-10', 'matteo.esposito@email.it','3557654321');

INSERT INTO appointment (patient_id, doctor_id, scheduled_at, visit_type, status) VALUES
    (1, 1, DATEADD(DAY, 2,  NOW()), 'Cardiology Check-up',  'BOOKED'),
    (2, 2, DATEADD(DAY, 3,  NOW()), 'General Medicine Visit','CONFIRMED'),
    (3, 3, DATEADD(DAY, -5, NOW()), 'Orthopedic Visit',      'COMPLETED');

INSERT INTO report (appointment_id, diagnosis, prescription, doctor_notes) VALUES
    (3, 'Right knee tendinitis', 'Complete rest for 2 weeks, ibuprofen 400mg 3 times a day', 'Re-evaluation in 15 days');
