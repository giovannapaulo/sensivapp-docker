import os
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://sensiv:password@db:5432/sensivapp_db")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class SintomaModel(Base):
    __tablename__ = "sintomas"

    id = Column(Integer, primary_key=True, index=True)
    intensidade = Column(String(50), nullable=False)
    descricao = Column(Text, nullable=True)

Base.metadata.create_all(bind=engine)

app = FastAPI(title="SensivApp - Diário de Sintomas API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class SintomaSchema(BaseModel):
    intensidade: str
    descricao: str

    class Config:
        from_attributes = True

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_root():
    return {"message": "API do SensivApp rodando com sucesso no cluster Swarm!"}

@app.post("/sintomas/", response_model=SintomaSchema)
def criar_sintoma(sintoma: SintomaSchema, db: Session = Depends(get_db)):
    novo_sintoma = SintomaModel(intensidade=sintoma.intensidade, descricao=sintoma.descricao)
    db.add(novo_sintoma)
    db.commit()
    db.refresh(novo_sintoma)
    return novo_sintoma

@app.get("/sintomas/")
def listar_sintomas(db: Session = Depends(get_db)):
    return db.query(SintomaModel).all()