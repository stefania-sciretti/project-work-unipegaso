# Apice Clinic — Project Work Unipegaso

> **Corso:** Informatica per le Imprese Digitali — Università Telematica Pegaso  
> **Studente:** Stefania Sciretti  
> **A.A.:** 2025/2026

---

## Indice

1. [Contesto e scenario d'uso](#1-contesto-e-scenario-duso)
2. [Architettura del sistema](#2-architettura-del-sistema)
3. [Design — Diagramma ER](#3-design--diagramma-er)
4. [Design — Diagramma UML delle classi](#4-design--diagramma-uml-delle-classi)
5. [Documentazione API (Swagger)](#5-documentazione-api-swagger)
6. [Stack tecnologico](#6-stack-tecnologico)
7. [Struttura del repository](#7-struttura-del-repository)
8. [Snippet di codice rilevanti](#8-snippet-di-codice-rilevanti)
9. [Come avviare il progetto](#9-come-avviare-il-progetto)
10. [Test funzionale](#10-test-funzionale)

---

## 1. Contesto e scenario d'uso

### L'organizzazione

**Apice Clinic** è una clinica privata specializzata in **nutrizione clinica e medicina dello sport**, che eroga prestazioni sanitarie integrate per pazienti e atleti. Opera nel **settore sanitario** a tutti gli effetti, in quanto:

- eroga **prestazioni sanitarie riconosciute**: visite nutrizionistiche, valutazioni medico-sportive, check-up metabolici, monitoraggio glicemico;
- coinvolge **figure professionali sanitarie**: medici nutrizionisti, dietiste cliniche, medici dello sport, personal trainer certificati;
- gestisce **dati sanitari sensibili**: anamnesi, referti medici, parametri fisici, piani terapeutici e di allenamento.

Le figure professionali operative sono:

- **Dott.ssa Simona Ruberti** — Medico nutrizionista, specializzata in nutrizione clinica e sportiva. Segue i pazienti con piani alimentari personalizzati, controlli metabolici (glicemia, composizione corporea) e supporto nutrizionale per la performance atletica.
- **Luca Siretta** — Personal Trainer certificato ISSA e preparatore atletico, specializzato in functional training e preparazione atletica. Lavora in sinergia con la dottoressa Simona per integrare piano nutrizionale e scheda di allenamento.

I pazienti e clienti del centro hanno obiettivi eterogenei: gestione del peso, miglioramento delle performance sportive, controllo di parametri metabolici (glicemia, colesterolo), recupero post-infortunio, preparazione a competizioni agonistiche.

### Il contesto sanitario

Una clinica di nutrizione e medicina dello sport rientra a pieno titolo nel **settore sanitario** perché:

- la **nutrizione clinica** è una branca della medicina riconosciuta dal SSN;
- i **medici nutrizionisti e dietisti** sono figure sanitarie iscritte agli albi professionali;
- la **medicina dello sport** include valutazioni mediche obbligatorie per l'idoneità agonistica;
- il **monitoraggio di parametri vitali** (glicemia, pressione, composizione corporea) costituisce attività sanitaria.

L'applicazione gestisce quindi dati che, in un contesto reale, sarebbero soggetti alla normativa GDPR per i **dati particolari** (art. 9 GDPR) e al Codice della Privacy in ambito sanitario.

### Il problema

Prima dell'applicazione, la gestione della clinica avveniva tramite fogli Excel e comunicazioni via WhatsApp/email, con problemi di:

- Doppia prenotazione degli slot orari tra le diverse figure professionali
- Impossibilità di tracciare lo storico dei piani nutrizionali, delle schede di allenamento e dei parametri clinici
- Nessuna dashboard riepilogativa dell'attività clinica e dei KPI operativi
- Dispersione delle informazioni tra modulo sanitario (pazienti, referti, visite mediche) e modulo wellness (clienti, allenamenti, ricette)

### La soluzione

Un'**applicazione web full-stack API-based** con:

- **Frontend Angular** per la gestione operativa quotidiana (prenotazioni, pazienti, clienti, piani, referti, glicemia)
- **Backend REST API Spring Boot (Kotlin)** che espone tutti i servizi in modo standardizzato e documentato via Swagger
- **Database PostgreSQL** come sistema di persistenza con migrazione versionata (Flyway)

### Servizi implementati

| Modulo | Descrizione |
|--------|-------------|
| 🏥 **Pazienti** | Anagrafica pazienti con codice fiscale, dati anagrafici e storico visite |
| 👨‍⚕️ **Medici** | Registro dei medici con specializzazione e numero di iscrizione all'albo |
| 📅 **Visite Mediche** | Prenotazione e gestione stati (BOOKED → CONFIRMED → COMPLETED) |
| 📋 **Referti** | Diagnosi, prescrizioni e note cliniche associate a ogni visita |
| 👥 **Clienti** | Anagrafica clienti del centro con obiettivi personali |
| 🥗 **Piani Nutrizionali** | Piani alimentari personalizzati assegnati da Simona |
| 💪 **Schede Allenamento** | Programmi di training assegnati da Luca |
| 🍽️ **Ricette Fit** | Ricettario healthfood curato da Simona |
| 🩸 **Glicemia** | Monitoraggio glicemico tramite pungidito con classificazione automatica ADA/OMS |
| 🏠 **Dashboard** | KPI riepilogative: pazienti, visite, piani attivi, misurazioni |

---

## 2. Architettura del sistema

```
┌─────────────────────────────────────────────────────────┐
│                   BROWSER (Angular 14)                   │
│  Components: Dashboard │ Clients │ Appointments          │
│              Nutrition │ Training │ Recipes               │
│  Services: HTTP Client → REST calls                      │
└──────────────────────────┬──────────────────────────────┘
                           │ HTTP/JSON  (porta 4200 dev / 8080 prod)
┌──────────────────────────▼──────────────────────────────┐
│              BACKEND (Spring Boot 3.2 / Kotlin)          │
│  Controllers (REST)  →  Services  →  Repositories (JPA)  │
│  Swagger UI: /swagger-ui.html                            │
│  OpenAPI JSON: /v3/api-docs                              │
└──────────────────────────┬──────────────────────────────┘
                           │ JDBC / Hibernate
┌──────────────────────────▼──────────────────────────────┐
│              DATABASE (PostgreSQL 15)                    │
│  Schema gestito con Flyway (V1, V2, V3)                  │
│  Modulo clinico: patient, doctor, appointment, report    │
│  Modulo wellness: client, trainer, fitness_appointment,  │
│                   diet_plan, training_plan, recipe       │
│  Modulo monitoraggio: glycemia_measurement               │
└─────────────────────────────────────────────────────────┘
```

**Pattern architetturale:** Layered Architecture (Controller → Service → Repository → Domain)

---

## 3. Design — Diagramma ER

```
┌──────────────┐       ┌──────────────────────┐       ┌──────────────┐
│   CLIENT     │       │  FITNESS_APPOINTMENT  │       │   TRAINER    │
│──────────────│       │──────────────────────│       │──────────────│
│ id (PK)      │◄──────│ id (PK)              │──────►│ id (PK)      │
│ first_name   │  1:N  │ client_id (FK)       │  N:1  │ first_name   │
│ last_name    │       │ trainer_id (FK)      │       │ last_name    │
│ email        │       │ scheduled_at         │       │ role (ENUM)  │
│ phone        │       │ service_type         │       │ bio          │
│ birth_date   │       │ status (ENUM)        │       │ email        │
│ goal         │       │ notes                │       │ created_at   │
│ created_at   │       │ created_at           │       └──────────────┘
└──────┬───────┘       └──────────────────────┘              │
       │                                                      │
       │ 1:N           ┌──────────────┐              1:N     │
       └──────────────►│  DIET_PLAN   │◄─────────────────────┘
       │               │──────────────│
       │               │ id (PK)      │
       │               │ client_id FK │
       │               │ trainer_id FK│
       │               │ title        │
       │               │ description  │
       │               │ calories     │
       │               │ duration_wks │
       │               │ active       │
       │               └──────────────┘
       │
       │ 1:N           ┌──────────────────┐
       └──────────────►│  TRAINING_PLAN   │
                       │──────────────────│
                       │ id (PK)          │
                       │ client_id FK     │
                       │ trainer_id FK    │
                       │ title            │
                       │ description      │
                       │ weeks            │
                       │ sessions_per_wk  │
                       │ active           │
                       └──────────────────┘

┌──────────────┐   (entità indipendente, gestita da Simona)
│   RECIPE     │
│──────────────│
│ id (PK)      │
│ title        │
│ description  │
│ ingredients  │
│ instructions │
│ calories     │
│ category     │
│ created_at   │
└──────────────┘

ENUM trainer_role : NUTRITIONIST | PERSONAL_TRAINER
ENUM stato_visita : PRENOTATA | CONFERMATA | COMPLETATA | ANNULLATA
```

---

## 4. Design — Diagramma UML delle classi

```
┌──────────────────────────────────┐
│  <<entity>>  Client              │
│──────────────────────────────────│
│ - id: Long                       │
│ - firstName: String              │
│ - lastName: String               │
│ - email: String                  │
│ - phone: String?                 │
│ - birthDate: LocalDate?          │
│ - goal: String?                  │
│ - createdAt: LocalDateTime       │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│  <<entity>>  Trainer             │
│──────────────────────────────────│
│ - id: Long                       │
│ - firstName: String              │
│ - lastName: String               │
│ - role: TrainerRole              │
│ - bio: String?                   │
│ - email: String                  │
└──────────────────────────────────┘

┌──────────────────────────────────┐       usa        ┌──────────┐   ┌─────────┐
│  <<entity>>  FitnessAppointment  │ ────────────────► │  Client  │   │ Trainer │
│──────────────────────────────────│                   └──────────┘   └─────────┘
│ - id: Long                       │
│ - client: Client                 │
│ - trainer: Trainer               │
│ - scheduledAt: LocalDateTime     │
│ - serviceType: String            │
│ - status: AppointmentStatus      │
│ - notes: String?                 │
└──────────────────────────────────┘

┌────────────────────────────────────────┐
│  <<service>>  FitnessAppointmentService│
│────────────────────────────────────────│
│ + findAll(clientId, trainerId, status) │
│ + findById(id): Response               │
│ + create(request): Response            │
│ + updateStatus(id, request): Response  │
│ + delete(id)                           │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│  <<controller>>  FitnessApptController │
│────────────────────────────────────────│
│ GET    /api/appointments               │
│ GET    /api/appointments/{id}          │
│ POST   /api/appointments               │
│ PUT    /api/appointments/{id}/status   │
│ DELETE /api/appointments/{id}          │
└────────────────────────────────────────┘

<<enum>> AppointmentStatus
  PRENOTATA | CONFERMATA | COMPLETATA | CANCELLED | BOOKED | COMPLETED

<<enum>> TrainerRole
  NUTRITIONIST | PERSONAL_TRAINER
```

---

## 5. Documentazione API (Swagger)

Con il backend avviato, la documentazione interattiva è disponibile a:

- **Swagger UI:** `http://localhost:8080/swagger-ui.html`
- **OpenAPI JSON:** `http://localhost:8080/v3/api-docs`

### Riepilogo endpoint REST

#### 👥 Clients — `/api/clients`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/clients` | Lista tutti i clienti (`?search=nome`) |
| GET | `/api/clients/{id}` | Dettaglio cliente |
| POST | `/api/clients` | Crea nuovo cliente |
| PUT | `/api/clients/{id}` | Aggiorna cliente |
| DELETE | `/api/clients/{id}` | Elimina cliente |

**ClientRequest esempio:**
```json
{
  "firstName": "Marco",
  "lastName": "Rossi",
  "email": "marco.rossi@email.it",
  "phone": "3331234567",
  "birthDate": "1990-05-15",
  "goal": "Perdere peso e tonificare"
}
```

#### 📅 Appointments — `/api/appointments`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/appointments` | Lista (`?clientId`, `?trainerId`, `?status`) |
| GET | `/api/appointments/{id}` | Dettaglio |
| POST | `/api/appointments` | Prenota nuovo appuntamento |
| PUT | `/api/appointments/{id}/status` | Aggiorna stato |
| DELETE | `/api/appointments/{id}` | Cancella |

**FitnessAppointmentRequest esempio:**
```json
{
  "clientId": 1,
  "trainerId": 1,
  "scheduledAt": "2026-04-15T10:00:00",
  "serviceType": "Consulenza Nutrizionale",
  "notes": "Prima visita"
}
```

#### 🥗 Diet Plans — `/api/diet-plans`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/diet-plans` | Lista piani (`?clientId`, `?active`) |
| POST | `/api/diet-plans` | Crea piano nutrizionale |
| PUT | `/api/diet-plans/{id}` | Aggiorna piano |
| DELETE | `/api/diet-plans/{id}` | Elimina piano |

#### 💪 Training Plans — `/api/training-plans`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/training-plans` | Lista schede (`?clientId`, `?active`) |
| POST | `/api/training-plans` | Crea scheda allenamento |
| PUT | `/api/training-plans/{id}` | Aggiorna scheda |
| DELETE | `/api/training-plans/{id}` | Elimina scheda |

#### 🍽️ Recipes — `/api/recipes`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/recipes` | Lista ricette (`?category`, `?search`) |
| POST | `/api/recipes` | Crea ricetta |
| PUT | `/api/recipes/{id}` | Aggiorna ricetta |
| DELETE | `/api/recipes/{id}` | Elimina ricetta |

#### 🏋️ Trainers — `/api/trainers`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/trainers` | Lista trainer (`?role=NUTRITIONIST`) |
| GET | `/api/trainers/{id}` | Dettaglio trainer |

#### 🏠 Dashboard — `/api/dashboard`

| Metodo | Endpoint | Descrizione |
|--------|----------|-------------|
| GET | `/api/dashboard` | KPI riepilogative del centro |

**DashboardResponse esempio:**
```json
{
  "totalClients": 5,
  "totalAppointments": 5,
  "bookedAppointments": 2,
  "completedAppointments": 2,
  "activeDietPlans": 2,
  "activeTrainingPlans": 2,
  "totalRecipes": 5
}
```

---

## 6. Stack tecnologico

| Layer | Tecnologia | Versione |
|-------|-----------|---------|
| **Frontend** | Angular (standalone) | 14.x |
| **Frontend styling** | CSS custom | — |
| **Backend language** | Kotlin | 1.9.22 |
| **Backend framework** | Spring Boot | 3.2.3 |
| **ORM** | Spring Data JPA / Hibernate | — |
| **Database** | PostgreSQL | 15 |
| **DB Migration** | Flyway | — |
| **API Documentation** | SpringDoc OpenAPI (Swagger UI) | 2.3.0 |
| **Build tool** | Maven | 3.x |
| **Java runtime** | Java | 17 |
| **Validation** | Jakarta Bean Validation | — |
| **Testing** | JUnit 5 + Mockito-Kotlin | — |

---

## 7. Struttura del repository

```
project-work-unipegaso/
├── backend/                          # Spring Boot API (Kotlin)
│   ├── pom.xml
│   └── src/main/kotlin/com/clinica/
│       ├── ClinicaApplication.kt     # Entry point Spring Boot
│       ├── config/                   # CORS, OpenAPI config
│       ├── controller/               # REST Controllers
│       │   ├── ClientController.kt
│       │   ├── FitnessAppointmentController.kt
│       │   ├── DietPlanController.kt
│       │   ├── TrainingPlanController.kt
│       │   ├── RecipeController.kt
│       │   ├── TrainerController.kt
│       │   └── DashboardController.kt
│       ├── service/                  # Business logic
│       ├── repository/               # Spring Data JPA repositories
│       ├── domain/                   # Entity JPA (@Entity)
│       └── dto/                      # Request/Response DTOs (data class)
│   └── src/main/resources/
│       ├── application.yml
│       └── db/migration/
│           ├── V1__init.sql          # Schema legacy (clinica)
│           └── V2__fitness_schema.sql # Schema CentroFitness
│
├── frontend/                         # Angular 14 SPA
│   ├── package.json
│   ├── proxy.conf.json               # Proxy dev → backend :8080
│   └── src/app/
│       ├── app.component.ts          # Root component (standalone)
│       ├── app.config.ts             # Bootstrap providers
│       ├── app.routes.ts             # Routing lazy-loaded
│       ├── components/navbar/        # Navbar con RouterLink
│       ├── models/models.ts          # TypeScript interfaces
│       ├── services/                 # HTTP services (HttpClient)
│       └── pages/                   # Feature pages
│           ├── dashboard/
│           ├── clients/
│           ├── appointments/
│           ├── nutrition/
│           ├── training/
│           └── recipes/
│
└── README.md                         # Questo documento
```

---

## 8. Snippet di codice rilevanti

### 8.1 — Service layer con pattern `when` e transazioni Kotlin

```kotlin
@Service
@Transactional
class FitnessAppointmentService(
    private val appointmentRepository: FitnessAppointmentRepository,
    private val clientRepository: ClientRepository,
    private val trainerRepository: TrainerRepository
) {
    @Transactional(readOnly = true)
    fun findAll(clientId: Long?, trainerId: Long?, status: String?): List<FitnessAppointmentResponse> {
        val list = when {
            clientId  != null -> appointmentRepository.findByClientId(clientId)
            trainerId != null -> appointmentRepository.findByTrainerId(trainerId)
            status    != null -> appointmentRepository.findByStatus(
                                     AppointmentStatus.valueOf(status.uppercase()))
            else -> appointmentRepository.findAll()
        }
        return list.map { it.toResponse() }
    }
}
```

**Perché è interessante:** L'espressione `when` di Kotlin sostituisce una catena di `if-else` rendendola compatta e type-safe. `@Transactional(readOnly = true)` ottimizza le query di lettura disabilitando il dirty-checking di Hibernate.

---

### 8.2 — REST Controller con annotazioni OpenAPI auto-documentanti

```kotlin
@RestController
@RequestMapping("/api/appointments")
@Tag(name = "Appointments", description = "Fitness appointment booking and management")
class FitnessAppointmentController(private val svc: FitnessAppointmentService) {

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Book a new appointment")
    fun create(@Valid @RequestBody request: FitnessAppointmentRequest) =
        svc.create(request)

    @PutMapping("/{id}/status")
    @Operation(summary = "Update appointment status")
    fun updateStatus(@PathVariable id: Long,
                     @Valid @RequestBody req: FitnessAppointmentStatusRequest) =
        svc.updateStatus(id, req)
}
```

**Perché è interessante:** Le annotation `@Tag` e `@Operation` di SpringDoc generano automaticamente la Swagger UI su `/swagger-ui.html` senza scrivere YAML manualmente. `@Valid` attiva la validazione Jakarta Bean Validation prima ancora di entrare nel service.

---

### 8.3 — Data class Kotlin come DTO immutabile e validato

```kotlin
data class FitnessAppointmentRequest(
    @field:NotNull(message = "Client ID is required")
    val clientId: Long,

    @field:NotNull(message = "Trainer ID is required")
    val trainerId: Long,

    @field:NotNull(message = "Scheduled date/time is required")
    val scheduledAt: LocalDateTime,

    @field:NotBlank(message = "Service type is required")
    val serviceType: String,

    val notes: String? = null   // nullable con default: campo opzionale
)
```

**Perché è interessante:** Le `data class` di Kotlin generano automaticamente `equals()`, `hashCode()`, `toString()` e `copy()`. I tipi nullable (`String?`) comunicano esplicitamente l'opzionalità senza annotazioni aggiuntive.

---

### 8.4 — Angular standalone component con lazy loading e reactive forms

```typescript
// app.routes.ts — lazy loading per performance
export const routes: Routes = [
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
  {
    path: 'appointments',
    loadComponent: () =>
      import('./pages/appointments/appointments.component')
        .then(m => m.AppointmentsComponent)
  }
};

// clients.component.ts — reactive form con validazione
@Component({ standalone: true, imports: [CommonModule, ReactiveFormsModule], ... })
export class ClientsComponent implements OnInit {
  form!: FormGroup;

  ngOnInit(): void {
    this.form = this.fb.group({
      firstName: ['', Validators.required],
      email:     ['', [Validators.required, Validators.email]],
    });
  }

  save(): void {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    const obs = this.editingId
      ? this.svc.update(this.editingId, this.form.value)
      : this.svc.create(this.form.value);
    obs.subscribe({ next: () => this.load(), error: (e) => this.showAlert(e.message, 'error') });
  }
}
```

**Perché è interessante:** Il lazy loading carica il codice del componente solo quando l'utente naviga su quella rotta, riducendo il bundle iniziale. Il pattern standalone elimina l'`NgModule` riducendo il boilerplate.

---

### 8.5 — Schema DB con Flyway e ENUM PostgreSQL

```sql
-- V2__fitness_schema.sql
CREATE TYPE trainer_role AS ENUM ('NUTRITIONIST', 'PERSONAL_TRAINER');

CREATE TABLE fitness_appointment (
    id           BIGSERIAL    PRIMARY KEY,
    client_id    BIGINT       NOT NULL REFERENCES client(id)  ON DELETE RESTRICT,
    trainer_id   BIGINT       NOT NULL REFERENCES trainer(id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMP    NOT NULL,
    status       stato_visita NOT NULL DEFAULT 'PRENOTATA',
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fitness_appt_status ON fitness_appointment(status);
```

**Perché è interessante:** Flyway garantisce che le modifiche al DB siano tracciate e versionabili come il codice. Gli ENUM PostgreSQL garantiscono l'integrità dei dati a livello database, non solo applicativo. Gli indici su `status` e `client_id` ottimizzano le query di filtraggio più frequenti.

---

## 9. Come avviare il progetto

### Prerequisiti

- Java 17+, Maven 3.8+
- Node.js 18+, npm
- PostgreSQL 15 su `localhost:5432`

### 1. Creare il database PostgreSQL

```sql
CREATE DATABASE centrofitness;
```

### 2. Avviare il backend

```bash
cd backend
mvn spring-boot:run
```

Flyway esegue automaticamente le migrazioni e carica i dati di esempio al primo avvio.

- API disponibile su: `http://localhost:8080/api`
- Swagger UI: `http://localhost:8080/swagger-ui.html`

### 3. Avviare il frontend in sviluppo

```bash
cd frontend
npm install
ng serve
# oppure: node_modules/.bin/ng serve
```

App disponibile su: `http://localhost:4200`  
Il proxy (`proxy.conf.json`) instrada `/api/*` → `http://localhost:8080`.

### 4. Build integrato (frontend + backend su porta 8080)

```bash
cd frontend
npm run build          # output → backend/src/main/resources/static/
cd ../backend
mvn spring-boot:run    # serve API + frontend statico
```

App completa su: `http://localhost:8080`

---

## 10. Test funzionale

### Test del backend

```bash
cd backend
mvn test
```

I test coprono i service layer con Mockito-Kotlin, verificando la logica di business indipendentemente dal database.

### Verifica via Swagger UI

Con backend avviato su `http://localhost:8080/swagger-ui.html`:

1. **GET /api/dashboard** → statistiche del centro (5 clienti, 5 appuntamenti, ...)
2. **GET /api/clients** → lista i 5 clienti pre-caricati (Marco, Giulia, Francesca, Andrea, Sofia)
3. **POST /api/appointments** → crea un nuovo appuntamento con `clientId=1, trainerId=1`
4. **PUT /api/appointments/{id}/status** → aggiorna lo stato a `CONFERMATA`
5. **GET /api/recipes** → lista le 5 ricette fit pre-caricate

### Verifica via frontend Angular

1. Aprire `http://localhost:4200`
2. La **Dashboard** mostra i KPI del centro in tempo reale
3. **Clients** → CRUD completo: aggiungere, modificare, cercare ed eliminare clienti
4. **Appointments** → prenotare appuntamenti e aggiornare lo stato
5. **Simona (Nutrition)** → gestire piani nutrizionali, filtro attivi/non attivi
6. **Luca (Training)** → gestire schede allenamento
7. **Recipes** → consultare e gestire il ricettario fit

---

*Progetto sviluppato come elaborato finale per il corso di Informatica per le Imprese Digitali — Università Telematica Pegaso, A.A. 2025/2026.*
