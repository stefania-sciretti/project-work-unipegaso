-- ===================================================
-- CentroFitness Simona & Luca - Schema esteso
-- V2__fitness_schema.sql
-- ===================================================

-- Tipo ENUM stato appuntamento: appointment_status già creato in V1 (BOOKED, CONFIRMED, COMPLETED, CANCELLED)

-- Tabella CLIENT (clienti del centro fitness)
CREATE TABLE client (
    id           BIGSERIAL    PRIMARY KEY,
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(20),
    birth_date   DATE,
    goal         TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella STAFF (Simona e Luca)
CREATE TABLE staff (
    id         BIGSERIAL    PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    role       VARCHAR(50)  NOT NULL,
    bio        TEXT,
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella APPOINTMENT (prenotazioni per Simona o Luca)
CREATE TABLE fitness_appointment (
    id           BIGSERIAL    PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id)  ON DELETE RESTRICT,
    trainer_id   BIGINT       NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMP    NOT NULL,
    service_type VARCHAR(200) NOT NULL,
    status       appointment_status NOT NULL DEFAULT 'BOOKED',
    notes        TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella DIET_PLAN (piani dietetici di Simona)
CREATE TABLE diet_plan (
    id           BIGSERIAL    PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id) ON DELETE RESTRICT,
    trainer_id   BIGINT       NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    calories     INT,
    duration_weeks INT,
    active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella TRAINING_PLAN (schede di allenamento di Luca)
CREATE TABLE training_plan (
    id             BIGSERIAL    PRIMARY KEY,
    client_id      BIGINT       NOT NULL REFERENCES client(id)  ON DELETE RESTRICT,
    trainer_id     BIGINT       NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
    title          VARCHAR(255) NOT NULL,
    description    TEXT,
    weeks          INT,
    sessions_per_week INT,
    active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella RECIPE (ricette fit di Simona)
CREATE TABLE recipe (
    id           BIGSERIAL    PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    ingredients  TEXT,
    instructions TEXT,
    calories     INT,
    category     VARCHAR(100),
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Indici
CREATE INDEX idx_fitness_appt_client  ON fitness_appointment(client_id);
CREATE INDEX idx_fitness_appt_trainer ON fitness_appointment(trainer_id);
CREATE INDEX idx_fitness_appt_status  ON fitness_appointment(status);
CREATE INDEX idx_diet_plan_client     ON diet_plan(client_id);
CREATE INDEX idx_training_plan_client ON training_plan(client_id);

-- ── Dati di esempio: staff ──
INSERT INTO staff (first_name, last_name, role, bio, email) VALUES
    ('Simona',   'Ruberti',  'NUTRITIONIST',
     'Biologa Nutrizionista con 10 anni di esperienza in diete sportive e benessere. Specializzata in piani alimentari personalizzati.',
     'simona@centrofitness.it'),
    ('Luca',     'Siretta',  'PERSONAL_TRAINER',
     'Personal Trainer ISSA certificato con passione per il functional training. Aiuta i clienti a raggiungere i loro obiettivi con schede di allenamento su misura.',
     'luca@centrofitness.it'),
    ('Sandro',   'Scrigoni', 'SPORTS_DOCTOR',
     'Medico dello Sport specializzato in valutazioni funzionali e prevenzione degli infortuni.',
     'sandro@centrofitness.it'),
    ('Mihai',    'Lavretti', 'OSTEOPATH',
     'Osteopata con approccio integrato al trattamento delle disfunzioni muscolo-scheletriche.',
     'mihai@centrofitness.it'),
    ('Cristiana','Maratti',  'SPORTS_NUTRITIONIST',
     'Nutrizionista Sportiva specializzata in nutrizione per la performance e il recupero atletico.',
     'cristiana@centrofitness.it');

-- ── Dati di esempio: clienti ──
INSERT INTO client (first_name, last_name, email, phone, birth_date, goal) VALUES
    ('Simona',       'Sorino',         'simona.sorino@email.it',        '3669900112', '1996-11-02', 'Dimagrimento e benessere'),
    ('Alessia',      'Audace',         'alessia.audace@email.it',       '3557788990', '1997-01-14', 'Tonificare il corpo'),
    ('Marco',        'Lavecri',        'marco.lavecri@email.it',        '3425566779', '1998-12-19', 'Perdere peso e tonificare'),
    ('Elena',        'Debuo',          'elena.debuo@email.it',          '3331122334', '1996-09-07', 'Aumentare massa muscolare'),
    ('Erica',        'Guella',         'erica.guella@email.it',         '3445566778', '2000-09-23', 'Migliorare resistenza'),
    ('Serena',       'Degevere',       'serena.degevere@email.it',      '3471234567', '2000-09-17', 'Alimentazione equilibrata'),
    ('Andrea',       'Selino',         'andrea.selino@email.it',        '3449988776', '1990-02-11', 'Prepararsi per una gara'),
    ('Deborah',      'Lovorgio',       'deborah.lovorgio@email.it',     '3489876543', '2000-05-13', 'Perdere peso'),
    ('Nadia',        'Pietri',         'nadia.pietri@email.it',         '3507654321', '1999-07-18', 'Benessere generale'),
    ('Anna',         'Francis',        'anna.francis@email.it',         '3516543210', '2000-06-19', 'Alimentazione sana'),
    ('Sebastian',    'Andorno',        'sebastian.andorno@email.it',    '3557711223', '1998-07-04', 'Aumentare massa muscolare'),
    ('Robert',       'Dogri',          'robert.dogri@email.it',         '3661100334', '1996-06-30', 'Migliorare performance sportiva'),
    ('Daniele',      'Cappello',       'daniele.cappello@email.it',     '3334455667', '1998-03-09', 'Definizione muscolare'),
    ('Maximilian',   'Ceolia',         'maximilian.ceolia@email.it',    '3381122445', '2001-09-09', 'Aumentare forza'),
    ('Iulia',        'Massimiliani',   'iulia.massimiliani@email.it',   '3392233556', '2003-04-23', 'Alimentazione equilibrata'),
    ('Marcelin',     'Ceolia',         'marcelin.ceolia@email.it',      '3403344667', '2002-08-31', 'Perdere peso e tonificare'),
    ('Alessandru',   'Davini',         'alessandru.davini@email.it',    '3414455778', '2000-03-28', 'Migliorare resistenza');

-- ── Dati di esempio: appuntamenti ──
INSERT INTO fitness_appointment (client_id, trainer_id, scheduled_at, service_type, status) VALUES
    (5, 1, NOW() + INTERVAL '2 days',  'Consulenza Nutrizionale',    'BOOKED'),
    (1, 2, NOW() + INTERVAL '1 day',   'Valutazione Fitness',        'CONFIRMED'),
    (2, 1, NOW() + INTERVAL '4 days',  'Piano Dieta Personalizzato', 'BOOKED'),
    (3, 2, NOW() - INTERVAL '3 days',  'Allenamento Funzionale',     'COMPLETED'),
    (4, 1, NOW() - INTERVAL '7 days',  'Follow-up Dieta',            'COMPLETED');

-- ── Dati di esempio: diete ──
INSERT INTO diet_plan (client_id, trainer_id, title, description, calories, duration_weeks, active) VALUES
    (5, 1, 'Piano Dimagrante Marco',   'Piano ipocalorico bilanciato con focus su proteine magre e verdure', 1800, 8,  true),
    (2, 1, 'Piano Equilibrio Serena',  'Alimentazione mediterranea arricchita di fibre e antiossidanti',    2000, 12, true),
    (4, 1, 'Piano Detox Simona',       'Piano depurativo con smoothie, insalate e cibi integrali',          1600, 4,  false);

-- ── Dati di esempio: schede allenamento ──
INSERT INTO training_plan (client_id, trainer_id, title, description, weeks, sessions_per_week, active) VALUES
    (1, 2, 'Massa Elena - Fase 1',  'Allenamento ipertrofico con split upper/lower 4 giorni a settimana', 8,  4, true),
    (3, 2, 'Pre-gara Andrea',       'Preparazione atletica con focus su resistenza e velocità',           12, 5, true),
    (5, 2, 'Full Body Marco',       'Scheda full body per principianti, 3 sessioni settimanali',          6,  3, false);

-- ── Dati di esempio: ricette ──
INSERT INTO recipe (title, description, ingredients, instructions, calories, category) VALUES
    ('Smoothie Proteico Verde',
     'Un frullato verde ricco di proteine ideale per il pre-workout',
     '1 banana, 30g spinaci freschi, 1 scoop proteine vaniglia, 200ml latte di mandorla, 1 cucchiaino burro di arachidi',
     'Inserire tutti gli ingredienti nel frullatore. Frullare per 60 secondi fino a ottenere un composto omogeneo. Servire subito.',
     320, 'Pre-Workout'),

    ('Bowl di Quinoa e Pollo',
     'Ricetta completa e bilanciata perfetta per il pranzo post-allenamento',
     '80g quinoa, 150g petto di pollo, 1 avocado, pomodorini, cetriolo, limone, olio EVO, sale, cumino',
     'Cuoci la quinoa in acqua salata per 15 min. Griglia il petto di pollo con spezie. Assembla la bowl con quinoa, pollo, avocado a fette e verdure. Condisci con limone e olio.',
     450, 'Pranzo Fit'),

    ('Pancakes Proteici all Avena',
     'Colazione dolce e proteica senza glutine raffinato',
     '60g farina di avena, 2 uova, 100g yogurt greco, 1 banana matura, 1 pizzico di bicarbonato, cannella',
     'Schiaccia la banana e mescola con uova e yogurt. Aggiungi la farina di avena, il bicarbonato e la cannella. Cuoci in padella antiaderente a fuoco medio, 2-3 min per lato.',
     380, 'Colazione'),

    ('Insalata Power con Salmone',
     'Ricca di Omega-3 e antiossidanti, ideale come cena leggera',
     '120g salmone affumicato, rucola, avocado, pomodorini, noci, olio EVO, limone, aneto',
     'Disponi la rucola nel piatto. Aggiungi il salmone a fette, avocado a cubetti, pomodorini e noci. Condisci con emulsione di olio e limone, guarnisci con aneto.',
     420, 'Cena Fit'),

    ('Energy Balls al Cacao',
     'Snack energetico sano da preparare in anticipo, senza cottura',
     '100g datteri, 50g mandorle, 2 cucchiai cacao amaro, 1 cucchiaio miele, cocco rapé q.b.',
     'Frulla i datteri e le mandorle nel mixer. Aggiungi cacao e miele, mescola fino a formare un impasto compatto. Forma palline e rotola nel cocco rapé. Conserva in frigo.',
     150, 'Snack');
