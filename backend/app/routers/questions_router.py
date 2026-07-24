# -*- coding: utf-8 -*-
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db, Question, User
from ..schemas import QuestionCreate, QuestionUpdate, QuestionOut
from ..auth import get_current_user, require_role

router = APIRouter(prefix="/questions", tags=["question-bank"])


@router.get("/", response_model=List[QuestionOut])
def list_questions(
    subject: Optional[str] = None,
    chapter: Optional[str] = None,
    difficulty: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Any logged-in user (student/teacher/admin) can browse the question bank."""
    q = db.query(Question)
    if subject:
        q = q.filter(Question.subject == subject)
    if chapter:
        q = q.filter(Question.chapter == chapter)
    if difficulty:
        q = q.filter(Question.difficulty == difficulty)
    return q.order_by(Question.id.desc()).all()


@router.get("/{question_id}", response_model=QuestionOut)
def get_question(question_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    question = db.query(Question).filter(Question.id == question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    return question


@router.post("/", response_model=QuestionOut, status_code=201)
def create_question(
    payload: QuestionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role("teacher", "admin")),
):
    question = Question(**payload.model_dump(), created_by=current_user.id)
    db.add(question)
    db.commit()
    db.refresh(question)
    return question


@router.put("/{question_id}", response_model=QuestionOut)
def update_question(
    question_id: int,
    payload: QuestionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role("teacher", "admin")),
):
    question = db.query(Question).filter(Question.id == question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(question, field, value)
    db.commit()
    db.refresh(question)
    return question


@router.delete("/{question_id}", status_code=204)
def delete_question(
    question_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role("teacher", "admin")),
):
    question = db.query(Question).filter(Question.id == question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    db.delete(question)
    db.commit()
    return None
