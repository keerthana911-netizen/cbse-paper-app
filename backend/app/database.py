# -*- coding: utf-8 -*-
from sqlalchemy import create_engine, Column, Integer, String, DateTime, Text
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import datetime

DATABASE_URL = "sqlite:///./cbse_app.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(String, nullable=False)  # "student" | "teacher" | "admin"
    created_at = Column(DateTime, default=datetime.utcnow)


class Question(Base):
    __tablename__ = "questions"
    id = Column(Integer, primary_key=True, index=True)
    subject = Column(String, nullable=False)       # "Math" | "English"
    chapter = Column(String, nullable=False)        # e.g. "Fractions"
    difficulty = Column(String, nullable=False)     # "Easy" | "Medium" | "Hard"
    question_text = Column(Text, nullable=False)
    option_a = Column(String, nullable=True)
    option_b = Column(String, nullable=True)
    option_c = Column(String, nullable=True)
    option_d = Column(String, nullable=True)
    correct_option = Column(String, nullable=True)  # "A"/"B"/"C"/"D", null for subjective
    answer_text = Column(Text, nullable=True)        # for subjective/short-answer questions
    marks = Column(Integer, nullable=False, default=1)
    question_type = Column(String, nullable=False, default="mcq")  # "mcq" | "short_answer" | "long_answer"
    created_by = Column(Integer, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class FixedPaper(Base):
    __tablename__ = "fixed_papers"
    id = Column(Integer, primary_key=True, index=True)
    subject = Column(String, nullable=False)
    difficulty = Column(String, nullable=False)
    marks = Column(Integer, nullable=False)
    paper_filename = Column(String, nullable=False)
    key_filename = Column(String, nullable=False)
    duration = Column(String, nullable=True)


def init_db():
    Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
