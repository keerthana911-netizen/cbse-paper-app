# -*- coding: utf-8 -*-
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


# ---- Auth ----
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    role: str = "student"  # student | teacher | admin


class UserOut(BaseModel):
    id: int
    name: str
    email: str
    role: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


# ---- Questions ----
class QuestionBase(BaseModel):
    subject: str
    chapter: str
    difficulty: str
    question_text: str
    option_a: Optional[str] = None
    option_b: Optional[str] = None
    option_c: Optional[str] = None
    option_d: Optional[str] = None
    correct_option: Optional[str] = None
    answer_text: Optional[str] = None
    marks: int = 1
    question_type: str = "mcq"


class QuestionCreate(QuestionBase):
    pass


class QuestionUpdate(BaseModel):
    subject: Optional[str] = None
    chapter: Optional[str] = None
    difficulty: Optional[str] = None
    question_text: Optional[str] = None
    option_a: Optional[str] = None
    option_b: Optional[str] = None
    option_c: Optional[str] = None
    option_d: Optional[str] = None
    correct_option: Optional[str] = None
    answer_text: Optional[str] = None
    marks: Optional[int] = None
    question_type: Optional[str] = None


class QuestionOut(QuestionBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


# ---- Fixed Papers ----
class FixedPaperOut(BaseModel):
    id: int
    subject: str
    difficulty: str
    marks: int
    duration: Optional[str]

    class Config:
        from_attributes = True
