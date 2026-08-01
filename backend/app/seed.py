# -*- coding: utf-8 -*-
"""
Run once after first install (or after adding new PDFs) to populate the database:
    python -m app.seed
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import SessionLocal, init_db, FixedPaper, User
from app.auth import hash_password

SUBJECTS = {
    "Math": {"prefix": "Math_CA1"},
    "English": {"prefix": "English_CA1"},
    "EVS": {"prefix": "EVS_CA1"},
    "Hindi": {"prefix": "Hindi_CA1"},
}
DIFFICULTIES = ["Easy", "Medium", "Hard"]
MARKS = [30, 50, 70]
DURATIONS = {30: "1 Hour", 50: "1 Hr 30 Min", 70: "2 Hr 30 Min"}

DEMO_USERS = [
    {"name": "Demo Student", "email": "student@example.com", "password": "student123", "role": "student"},
    {"name": "Demo Teacher", "email": "teacher@example.com", "password": "teacher123", "role": "teacher"},
    {"name": "Demo Admin", "email": "admin@example.com", "password": "admin123", "role": "admin"},
]


def seed():
    init_db()
    db = SessionLocal()
    try:
        # -- Fixed papers --
        added = 0
        for subject, info in SUBJECTS.items():
            for difficulty in DIFFICULTIES:
                for marks in MARKS:
                    prefix = info["prefix"]
                    paper_fn = f"{prefix}_{marks}M_{difficulty}.pdf"
                    key_fn = f"{prefix}_{marks}M_{difficulty}_AnswerKey.pdf"
                    exists = (
                        db.query(FixedPaper)
                        .filter(FixedPaper.subject == subject, FixedPaper.difficulty == difficulty, FixedPaper.marks == marks)
                        .first()
                    )
                    if exists:
                        continue
                    db.add(FixedPaper(
                        subject=subject,
                        difficulty=difficulty,
                        marks=marks,
                        paper_filename=paper_fn,
                        key_filename=key_fn,
                        duration=DURATIONS[marks],
                    ))
                    added += 1
        db.commit()
        print(f"Seeded {added} fixed-paper records (36 combinations expected: 4 subjects x 3 difficulties x 3 marks).")

        # -- Demo users --
        users_added = 0
        for u in DEMO_USERS:
            exists = db.query(User).filter(User.email == u["email"]).first()
            if exists:
                continue
            db.add(User(
                name=u["name"],
                email=u["email"],
                hashed_password=hash_password(u["password"]),
                role=u["role"],
            ))
            users_added += 1
        db.commit()
        print(f"Seeded {users_added} demo user(s). Login with, e.g., student@example.com / student123")

    finally:
        db.close()


if __name__ == "__main__":
    seed()
