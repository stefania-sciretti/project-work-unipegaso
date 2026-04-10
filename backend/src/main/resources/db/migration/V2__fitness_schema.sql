-- ===================================================
-- CentroFitness Simona & Luca - Schema esteso
-- V2__fitness_schema.sql
-- ===================================================

-- Tipo ENUM ruolo trainer
CREATE TYPE trainer_role AS ENUM ('NUTRITIONIST', 'PERSONAL_TRAINER');

-- Tipo ENUM stato appuntamento (manteniamo la compatibilità)
-- stato_visita già creato in V1

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

-- Tabella TRAINER (Simona e Luca)
CREATE TABLE trainer (
    id         BIGSERIAL    PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    role       trainer_role NOT NULL,
    bio        TEXT,
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella APPOINTMENT (prenotazioni per Simona o Luca)
CREATE TABLE fitness_appointment (
    id           BIGSERIAL    PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id)  ON DELETE RESTRICT,
    trainer_id   BIGINT       NOT NULL REFERENCES trainer(id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMP    NOT NULL,
    service_type VARCHAR(200) NOT NULL,
    status       stato_visita NOT NULL DEFAULT 'PRENOTATA',
    notes        TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Tabella DIET_PLAN (piani dietetici di Simona)
CREATE TABLE diet_plan (
    id           BIGSERIAL    PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id) ON DELETE RESTRICT,
    trainer_id   BIGINT       NOT NULL REFERENCES trainer(id) ON DELETE RESTRICT,
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
    trainer_id     BIGINT       NOT NULL REFERENCES trainer(id) ON DELETE RESTRICT,
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

-- ── Dati di esempio: trainer ──
INSERT INTO trainer (first_name, last_name, role, bio, email) VALUES
    ('Simona', 'Ruberti', 'NUTRITIONIST',
     'Nutrizionista certificata con 10 anni di esperienza in diete sportive e benessere. Specializzata in piani alimentari personalizzati.',
     'simona@centrofitness.it'),
    ('Luca',   'Siretta', 'PERSONAL_TRAINER',
     'Personal Trainer CONI certificato con passione per il functional training. Aiuta i clienti a raggiungere i loro obiettivi con schede di allenamento su misura.',
     'luca@centrofitness.it');

-- ── Dati di esempio: clienti ──
INSERT INTO client (first_name, last_name, email, phone, birth_date, goal) VALUES
    ('Marco',    'Rossi',    'marco.rossi@email.it',    '3331234567', '1990-05-15', 'Perdere peso e tonificare'),
    ('Giulia',   'Bianchi',  'giulia.bianchi@email.it', '3449876543', '1995-03-22', 'Aumentare massa muscolare'),
    ('Francesca','Verdi',    'f.verdi@email.it',        '3557654321', '1988-11-08', 'Alimentazione equilibrata'),
    ('Andrea',   'Marino',   'a.marino@email.it',       '3665432100', '2000-07-30', 'Prepararsi per una gara'),
    ('Sofia',    'Esposito', 's.esposito@email.it',     '3471122334', '1993-01-18', 'Dimagrimento e benessere');

-- ── Dati di esempio: appuntamenti ──
INSERT INTO fitness_appointment (client_id, trainer_id, scheduled_at, service_type, status) VALUES
    (1, 1, NOW() + INTERVAL '2 days',  'Consulenza Nutrizionale', 'PRENOTATA'),
    (2, 2, NOW() + INTERVAL '1 day',   'Valutazione Fitness',     'CONFERMATA'),
    (3, 1, NOW() + INTERVAL '4 days',  'Piano Dieta Personalizzato', 'PRENOTATA'),
    (4, 2, NOW() - INTERVAL '3 days',  'Allenamento Funzionale',  'COMPLETATA'),
    (5, 1, NOW() - INTERVAL '7 days',  'Follow-up Dieta',         'COMPLETATA');

-- ── Dati di esempio: diete ──
INSERT INTO diet_plan (client_id, trainer_id, title, description, calories, duration_weeks, active) VALUES
    (1, 1, 'Piano Dimagrante Marco',    'Piano ipocalorico bilanciato con focus su proteine magre e verdure', 1800, 8, true),
    (3, 1, 'Piano Equilibrio Francesca','Alimentazione mediterranea arricchita di fibre e antiossidanti',    2000, 12, true),
    (5, 1, 'Piano Detox Sofia',         'Piano depurativo con smoothie, insalate e cibi integrali',          1600, 4, false);

-- ── Dati di esempio: schede allenamento ──
INSERT INTO training_plan (client_id, trainer_id, title, description, weeks, sessions_per_week, active) VALUES
    (2, 2, 'Massa Giulia - Fase 1',  'Allenamento ipertrofico con split upper/lower 4 giorni a settimana', 8, 4, true),
    (4, 2, 'Pre-gara Andrea',        'Preparazione atletica con focus su resistenza e velocità',           12, 5, true),
    (1, 2, 'Full Body Marco',        'Scheda full body per principianti, 3 sessioni settimanali',          6, 3, false);

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
