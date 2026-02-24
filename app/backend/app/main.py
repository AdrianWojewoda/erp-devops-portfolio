from fastapi import FastAPI
from app.db import check_db_connection

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/readiness")
def readiness():
    try:
        check_db_connection()
        return {"database": "reachable"}
    except Exception as e:
        return {"database": "unreachable", "error": str(e)}