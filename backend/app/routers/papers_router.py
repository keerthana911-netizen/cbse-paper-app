# -*- coding: utf-8 -*-
import os
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db, FixedPaper
from ..schemas import FixedPaperOut
from ..auth import get_current_user

router = APIRouter(prefix="/papers", tags=["papers"])

STATIC_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static", "papers")


@router.get("/list", response_model=List[FixedPaperOut])
def list_papers(
    subject: Optional[str] = None,
    difficulty: Optional[str] = None,
    marks: Optional[int] = None,
    db: Session = Depends(get_db),
):
    """List all available fixed CA-1 papers, optionally filtered."""
    q = db.query(FixedPaper)
    if subject:
        q = q.filter(FixedPaper.subject == subject)
    if difficulty:
        q = q.filter(FixedPaper.difficulty == difficulty)
    if marks:
        q = q.filter(FixedPaper.marks == marks)
    return q.all()


@router.get("/fixed/{subject}/{difficulty}/{marks}")
def get_fixed_paper(subject: str, difficulty: str, marks: int, db: Session = Depends(get_db)):
    """Serve the question paper PDF directly (no auth required, matches original spec)."""
    record = (
        db.query(FixedPaper)
        .filter(FixedPaper.subject == subject, FixedPaper.difficulty == difficulty, FixedPaper.marks == marks)
        .first()
    )
    if not record:
        raise HTTPException(status_code=404, detail="No paper found for that subject/difficulty/marks combination")
    path = os.path.join(STATIC_DIR, record.paper_filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail="Paper file is missing on the server")
    return FileResponse(path, media_type="application/pdf", filename=record.paper_filename)


@router.get("/fixed/{subject}/{difficulty}/{marks}/key")
def get_fixed_paper_key(
    subject: str,
    difficulty: str,
    marks: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    """Serve the answer key PDF -- requires login (teachers/students with an account)."""
    record = (
        db.query(FixedPaper)
        .filter(FixedPaper.subject == subject, FixedPaper.difficulty == difficulty, FixedPaper.marks == marks)
        .first()
    )
    if not record:
        raise HTTPException(status_code=404, detail="No answer key found for that combination")
    path = os.path.join(STATIC_DIR, record.key_filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail="Answer key file is missing on the server")
    return FileResponse(path, media_type="application/pdf", filename=record.key_filename)
