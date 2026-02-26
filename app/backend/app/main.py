from fastapi import FastAPI, Response
from app.db import check_db_connection

from prometheus_client import CONTENT_TYPE_LATEST, generate_latest

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


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)