"""{{SERVICE_NAME}} - generated from the Acme golden-path template."""
from fastapi import FastAPI

app = FastAPI(title="{{SERVICE_NAME}}", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "{{SERVICE_NAME}}"}
