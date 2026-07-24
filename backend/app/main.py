# -*- coding: utf-8 -*-
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .database import init_db
from .routers import auth_router, papers_router, questions_router

app = FastAPI(
    title="CBSE Class 5 Paper API",
    description="Backend for the CA-1 question paper app: auth, fixed CA-1 papers, and question-bank CRUD.",
    version="1.0.0",
)

# Allow the Flutter app (mobile/web) to call this API from any origin during development.
# Tighten this to your actual app's origin(s) once you have a production domain.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router.router)
app.include_router(papers_router.router)
app.include_router(questions_router.router)


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/")
def root():
    return {
        "status": "ok",
        "message": "CBSE Class 5 Paper API is running.",
        "docs": "/docs",
    }


@app.get("/health")
def health():
    return {"status": "healthy"}
