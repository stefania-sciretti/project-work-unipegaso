-- ===================================================
-- CentroFitness Simona & Luca - Schema fitness (H2-compatible)
-- ===================================================

CREATE TABLE IF NOT EXISTS trainer (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    role       VARCHAR(30)  NOT NULL,
    bio        TEXT,
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS client (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(20),
    birth_date   DATE,
    goal         TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fitness_appointment (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id),
    trainer_id   BIGINT       NOT NULL REFERENCES trainer(id),
    scheduled_at TIMESTAMP    NOT NULL,
    service_type VARCHAR(200) NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'PRENOTATA',
    notes        TEXT,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS diet_plan (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id      BIGINT       NOT NULL REFERENCES client(id),
    trainer_id     BIGINT       NOT NULL REFERENCES trainer(id),
    title          VARCHAR(255) NOT NULL,
    description    TEXT,
    calories       INT,
    duration_weeks INT,
    active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS training_plan (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id         BIGINT       NOT NULL REFERENCES client(id),
    trainer_id        BIGINT       NOT NULL REFERENCES trainer(id),
    title             VARCHAR(255) NOT NULL,
    description       TEXT,
    weeks             INT,
    sessions_per_week INT,
    active            BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS recipe (
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    ingredients  TEXT,
    instructions TEXT,
    calories     INT,
    category     VARCHAR(100),
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ── Dati di esempio: trainer ──
INSERT INTO trainer (first_name, last_name, role, bio, email) VALUES
    ('Simona', 'Ruberti', 'NUTRITIONIST',
     'Nutrizionista certificata con 10 anni di esperienza in diete sportive e benessere.',
     'simona@centrofitness.it'),
    ('Luca', 'Siretta', 'PERSONAL_TRAINER',
     'Personal Trainer CONI certificato con passione per il functional training.',
     'luca@centrofitness.it');

-- ── Dati di esempio: clienti ──
INSERT INTO client (first_name, last_name, email, phone, birth_date, goal) VALUES
    ('Marco',     'Rossi',    'marco.rossi@email.it',    '3331234567', '1990-05-15', 'Perdere peso e tonificare'),
    ('Giulia',    'Bianchi',  'giulia.bianchi@email.it', '3449876543', '1995-03-22', 'Aumentare massa muscolare'),
    ('Francesca', 'Verdi',    'f.verdi@email.it',        '3557654321', '1988-11-08', 'Alimentazione equilibrata'),
    ('Andrea',    'Marino',   'a.marino@email.it',       '3665432100', '2000-07-30', 'Prepararsi per una gara'),
    ('Sofia',     'Esposito', 's.esposito@email.it',     '3471122334', '1993-01-18', 'Dimagrimento e benessere');

-- ── Dati di esempio: appuntamenti ──
INSERT INTO fitness_appointment (client_id, trainer_id, scheduled_at, service_type, status) VALUES
    (1, 1, DATEADD(DAY, 2,  NOW()), 'Consulenza Nutrizionale',     'PRENOTATA'),
    (2, 2, DATEADD(DAY, 1,  NOW()), 'Valutazione Fitness',          'CONFERMATA'),
    (3, 1, DATEADD(DAY, 4,  NOW()), 'Piano Dieta Personalizzato',   'PRENOTATA'),
    (4, 2, DATEADD(DAY, -3, NOW()), 'Allenamento Funzionale',       'COMPLETATA'),
    (5, 1, DATEADD(DAY, -7, NOW()), 'Follow-up Dieta',              'COMPLETATA');

-- ── Dati di esempio: diete ──
INSERT INTO diet_plan (client_id, trainer_id, title, description, calories, duration_weeks, active) VALUES
    (1, 1, 'Piano Dimagrante Marco',     'Piano ipocalorico bilanciato con focus su proteine magre e verdure', 1800, 8,  TRUE),
    (3, 1, 'Piano Equilibrio Francesca', 'Alimentazione mediterranea arricchita di fibre e antiossidanti',    2000, 12, TRUE),
    (5, 1, 'Piano Detox Sofia',          'Piano depurativo con smoothie, insalate e cibi integrali',          1600, 4,  FALSE);

-- ── Dati di esempio: schede allenamento ──
INSERT INTO training_plan (client_id, trainer_id, title, description, weeks, sessions_per_week, active) VALUES
    (2, 2, 'Massa Giulia - Fase 1', 'Allenamento ipertrofico con split upper/lower', 8,  4, TRUE),
    (4, 2, 'Pre-gara Andrea',       'Preparazione atletica con focus su resistenza',  12, 5, TRUE),
    (1, 2, 'Full Body Marco',       'Scheda full body per principianti',               6, 3, FALSE);

-- ── Dati di esempio: ricette ──
INSERT INTO recipe (title, description, ingredients, instructions, calories, category) VALUES
    ('Smoothie Proteico Verde',
     'Frullato verde ricco di proteine ideale per il pre-workout',
     '1 banana, 30g spinaci, 1 scoop proteine vaniglia, 200ml latte di mandorla',
     'Inserire tutti gli ingredienti nel frullatore. Frullare 60 secondi.',
     320, 'Pre-Workout'),
    ('Bowl di Quinoa e Pollo',
     'Ricetta completa per il pranzo post-allenamento',
     '80g quinoa, 150g petto di pollo, 1 avocado, pomodorini, limone, olio EVO',
     'Cuoci la quinoa. Griglia il pollo. Assembla la bowl con tutti gli ingredienti.',
     450, 'Pranzo Fit'),
    ('Pancakes Proteici all Avena',
     'Colazione dolce e proteica senza glutine raffinato',
     '60g farina di avena, 2 uova, 100g yogurt greco, 1 banana, cannella',
     'Mescola tutto. Cuoci in padella antiaderente 2-3 min per lato.',
     380, 'Colazione'),
    ('Insalata Power con Salmone',
     'Ricca di Omega-3 e antiossidanti, ideale come cena leggera',
     '120g salmone affumicato, rucola, avocado, pomodorini, noci, olio EVO',
     'Disponi la rucola. Aggiungi salmone, avocado e pomodorini. Condisci con olio e limone.',
     420, 'Cena Fit'),
    ('Energy Balls al Cacao',
     'Snack energetico sano senza cottura',
     '100g datteri, 50g mandorle, 2 cucchiai cacao amaro, 1 cucchiaio miele',
     'Frulla datteri e mandorle. Aggiungi cacao e miele. Forma palline. Conserva in frigo.',
     150, 'Snack');
