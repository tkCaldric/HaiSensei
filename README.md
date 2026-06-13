# はい、先生 (Hai, Sensei)
### Rule-Based Japanese Sentence Synthesizer (JLPT N5/N4)

`Hai, Sensei` is a full-stack web application designed for learning Japanese sentence construction (N5/N4 levels). Unlike modern AI translators, it operates on a **100% deterministic, rule-based conjugation engine**. It uses strict SQL text-matching, relational databases, and explicit morphological rules to conjugate verbs, format scripts with Furigana (Ruby tags), and structure grammatical variations.

---

## 🛠️ Architecture Stack

- **Frontend**: Angular (v18) + Tailwind CSS (configured with `Klee One` stroke/textbook typography)
- **Backend**: Java (Spring Boot 3)
- **Database**: PostgreSQL / H2 (utilizing JDBC and the DAO pattern)

---

## 🌟 Core Features

1. **Deterministic Rule-Based Conjugation Engine**:
   - Classifies verbs dynamically into Group 1 (Godan), Group 2 (Ichidan), and Group 3 (Irregular).
   - Rules-driven suffix adjustments for Polite Present Positive (-masu), Polite Present Negative (-masen), Polite Past Positive (-mashita), Polite Past Negative (-masendeshita), and Plain Dictionary Form.

2. **Interactive Sentence Slot Builder**:
   - Allows students to select sentence templates, subjects, objects, actions (verbs), and grammatical endings through 5 mechanical dropdown slots.
   - Outputs compiled results instantaneously.

3. **Textbook Typography & Furigana parsing**:
   - Integrates `Klee One`, a Japanese stroke/textbook-like font for authentic handwriting styles.
   - Built-in custom Angular pipe that automatically parses bracket notation (`Kanji[Kana]`) into standard HTML5 `<ruby>` elements.

4. **Fuzzy Phrase Matcher**:
   - Built-in RxJS debounced search box pulls relevant templates and settings directly from the database based on English meaning, matching slot structures immediately.

5. **Structural Alterations (Alternatives)**:
   - Includes a "Make another sample" cycle button that resolves and renders other active sentence templates sharing the identical intent category.

---

## 🚀 Getting Started

### 1. Requirements
- Node.js (v18+)
- Java JDK 17+
- Maven 3+

### 2. Running the Backend (Spring Boot)
The backend is configured to use a PostgreSQL-compatible in-memory database to allow instant, configuration-free testing out of the box.

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Build and run the service:
   ```bash
   mvn spring-boot:run
   ```
   *The server runs on `http://localhost:8080`.*

### 3. Running the Frontend (Angular)
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies (if not already done):
   ```bash
   npm install
   ```
3. Start the dev server:
   ```bash
   npm start
   ```
   *Open your browser to `http://localhost:4200`.*
