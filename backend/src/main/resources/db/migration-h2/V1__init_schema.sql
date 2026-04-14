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
    ('Simona',   'Ruberti',  'Biologa Nutrizionista', 'simona.ruberti@apiceclinic.it',   'RM-12345'),
    ('Luca',     'Siretta',  'Personal Trainer',        'luca.siretta@apiceclinic.it',     'MI-67890'),
    ('Sandro',   'Scrigoni', 'Medico dello Sport',         'sandro.scrigoni@apiceclinic.it',  'NA-11223'),
    ('Mihai',    'Lavretti', 'Osteopata',              'mihai.lavretti@apiceclinic.it',   'TO-44556'),
    ('Cristiana','Maratti',  'Nutrizionista Sportiva',     'cristiana.maratti@apiceclinic.it','FI-77889');

INSERT INTO patient (first_name, last_name, fiscal_code, birth_date, email, phone) VALUES
    ('Elena',     'Debuo',     'DBELNE96P47H501Q', '1996-09-07', 'elena.debuo@email.it',      '3331122334'),
    ('Erica',     'Guella',    'GLLERC00P63L219F', '2000-09-23', 'erica.guella@email.it',     '3445566778'),
    ('Alessia',   'Audace',    'DCALSS97A54F839M', '1997-01-14', 'alessia.audace@email.it',   '3557788990'),
    ('Simona',    'Sorino',    'SRNSMN96S42H501T', '1996-11-02', 'simona.sorino@email.it',    '3669900112'),
    ('Serena',    'Degevere',  'DGVSRN00P57H501B', '2000-09-17', 'serena.degevere@email.it',  '3471234567'),
    ('Deborah',   'Lovorgio',  'LVRDHR00E53L219W', '2000-05-13', 'deborah.lovorgio@email.it', '3489876543'),
    ('Nadia',     'Pietri',    'PTRNDA99L58F839K', '1999-07-18', 'nadia.pietri@email.it',     '3507654321'),
    ('Anna',      'Francis',   'FRCNNA00H59H501P', '2000-06-19', 'anna.francis@email.it',     '3516543210'),
    ('Andrea',      'Selino',         'SLNNDR90B11F839R', '1990-02-11', 'andrea.selino@email.it',         '3449988776'),
    ('Sebastian',   'Andorno',        'NDRSST98L04L219C', '1998-07-04', 'sebastian.andorno@email.it',     '3557711223'),
    ('Robert',      'Dogri',          'DGRRRT96H30H501V', '1996-06-30', 'robert.dogri@email.it',          '3661100334'),
    ('Daniele',     'Cappello',       'CPPDNL98C09L219X', '1998-03-09', 'daniele.cappello@email.it',      '3334455667'),
    ('Maximilian',  'Ceolia',         'CLOMXL01P09H501A', '2001-09-09', 'maximilian.ceolia@email.it',     '3381122445'),
    ('Iulia',       'Massimiliani',   'MSSLUI03D63L219B', '2003-04-23', 'iulia.massimiliani@email.it',    '3392233556'),
    ('Marcelin',    'Ceolia',         'CLOMCL02M31H501D', '2002-08-31', 'marcelin.ceolia@email.it',       '3403344667'),
    ('Alessandru',  'Davini',         'DVNLSN00C28F839E', '2000-03-28', 'alessandru.davini@email.it',     '3414455778'),
    ('Marco',       'Lavecri',        'LVRMRC98T19L219Z', '1998-12-19', 'marco.lavecri@email.it',          '3425566779');

INSERT INTO appointment (patient_id, doctor_id, scheduled_at, visit_type, status) VALUES
    (1,  1, DATEADD(DAY,  3, NOW()), 'Consulenza Nutrizionale',     'BOOKED'),
    (5,  3, DATEADD(DAY,  5, NOW()), 'Visita Medico Sportivo',      'CONFIRMED'),
    (9,  4, DATEADD(DAY, -7, NOW()), 'Seduta Osteopatica',          'COMPLETED'),
    (12, 5, DATEADD(DAY,  1, NOW()), 'Piano Nutrizionale Sportivo', 'BOOKED'),
    (17, 2, DATEADD(DAY, -2, NOW()), 'Valutazione Fitness',         'COMPLETED');

INSERT INTO report (appointment_id, diagnosis, prescription, doctor_notes) VALUES
    (3, 'Cervical muscle contracture', 'Osteopathic manipulation performed, 3 follow-up sessions recommended', 'Postural exercises twice a day'),
    (5, 'Good baseline fitness, mild core weakness', 'Custom training plan assigned - 3 sessions/week', 'Reassessment in 6 weeks');
