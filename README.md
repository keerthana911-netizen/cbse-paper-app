# CBSE Class 5 Paper Bank — Full App

Flutter frontend + FastAPI backend + SQLite database, built around the 36 CA-1 papers
(18 Math + 18 English) already generated.

## What's real vs. what needs your verification

- **Backend**: fully built and tested in a live sandbox session — login, role-based
  access control, PDF serving, and question-bank CRUD were all exercised end-to-end
  and work. You can run it as-is.
- **Frontend**: complete, structurally-checked Dart/Flutter source. I could not run
  `flutter pub get` / `flutter build` here (no access to pub.dev from this environment),
  so **you need to build it once yourself** to catch anything a real compiler would
  flag (package version bumps, minor API drift, etc.) before you trust it fully.

---

## 1. Backend setup (FastAPI + SQLite)

```bash
cd backend
python3 -m venv venv && source venv/bin/activate   # optional but recommended
pip install -r requirements.txt
python -m app.seed        # creates cbse_app.db, loads the 18 fixed-paper records + 3 demo users
uvicorn app.main:app --reload --port 8000
```

Visit `http://localhost:8000/docs` for interactive Swagger docs of every endpoint.

**Demo accounts** (created by the seed script):
| Role    | Email                  | Password    |
|---------|-------------------------|-------------|
| Student | student@example.com     | student123  |
| Teacher | teacher@example.com     | teacher123  |
| Admin   | admin@example.com       | admin123    |

### Key endpoints
- `POST /auth/register`, `POST /auth/login`, `GET /auth/me`
- `GET /papers/list?subject=Math&difficulty=Easy&marks=30` — list available fixed papers
- `GET /papers/fixed/{subject}/{difficulty}/{marks}` — download a question paper PDF (public)
- `GET /papers/fixed/{subject}/{difficulty}/{marks}/key` — download the answer key (login required)
- `GET/POST/PUT/DELETE /questions/` — question-bank CRUD (create/update/delete require teacher or admin role)

### Deploying to Render
`render.yaml` is included. Push this `backend/` folder to a GitHub repo, then in Render:
"New +" → "Blueprint" → point at the repo. It will run the seed script on build and
start the API. Set `CBSE_APP_SECRET_KEY` to something random in Render's env vars
(the blueprint auto-generates one, but double-check it under Environment).

---

## 2. Frontend setup (Flutter)

```bash
cd frontend
flutter pub get
flutter run          # or `flutter build apk` / `flutter build web`
```

Before running, open `lib/services/api_service.dart` and set `ApiConfig.baseUrl`:
- Pointing at your deployed Render backend (recommended), **or**
- `http://10.0.2.2:8000` if testing against a local backend from an Android emulator
- `http://localhost:8000` for iOS simulator / Flutter web

### Screens included
- **Role select** → **Login/Register** → **Home** (subject/difficulty/marks picker)
- **Paper view** — opens the question paper PDF externally, and fetches the answer
  key (auth-gated) as raw bytes
- **Question Bank** (teacher/admin only) — list, add, edit, delete questions, with
  subject filtering

### Known gaps to close before shipping
- PDF is opened externally via `url_launcher` rather than rendered in-app. If you
  want an in-app viewer, add `syncfusion_flutter_pdfviewer` or `flutter_pdfview` —
  I left a note in `paper_view_screen.dart` about this rather than guessing at a
  package version that might not build.
- Answer-key bytes are fetched but not yet saved/shared — wire up `path_provider` +
  `share_plus` (or similar) to save/open them, depending on what you want the UX to be.
- No password-reset flow, no offline caching — add if needed.

---

## 3. Folder structure

```
backend/
  app/
    main.py            # FastAPI app + routers
    database.py         # SQLAlchemy models (User, Question, FixedPaper) + SQLite setup
    schemas.py           # Pydantic request/response models
    auth.py               # JWT + password hashing + role-based access dependency
    seed.py                # populates fixed_papers table + demo users
    routers/
      auth_router.py
      papers_router.py
      questions_router.py
    static/papers/         # all 36 PDFs live here
  requirements.txt
  render.yaml

frontend/
  lib/
    main.dart
    models/models.dart
    services/api_service.dart
    services/auth_service.dart
    screens/
      role_select_screen.dart
      login_screen.dart
      home_screen.dart
      paper_view_screen.dart
      question_bank_screen.dart
      question_form_screen.dart
  pubspec.yaml
```
