"""Acme Retail Inventory Management System (IMS) - reference application."""
from typing import Annotated

from fastapi import Body, FastAPI, HTTPException, Query
from pydantic import BaseModel, Field, field_validator

app = FastAPI(title="Acme IMS", version="1.0.0")


class Item(BaseModel):
    sku: str = Field(min_length=1, max_length=64)
    name: str = Field(min_length=1, max_length=200)
    quantity: int = Field(ge=0)

    @field_validator("sku", "name")
    @classmethod
    def clean_optional_whitespace(cls, value: str) -> str:
        cleaned = value.strip()
        if not cleaned:
            raise ValueError("must not be blank")
        return cleaned


class StockDelta(BaseModel):
    delta: int


_DB: dict[str, Item] = {}


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/items", status_code=201)
def create_item(item: Item) -> Item:
    if item.sku in _DB:
        raise HTTPException(status_code=409, detail="SKU already exists")
    _DB[item.sku] = item
    return item


@app.get("/items/{sku}")
def get_item(sku: str) -> Item:
    sku = sku.strip()
    if not sku or sku not in _DB:
        raise HTTPException(status_code=404, detail="Not found")
    return _DB[sku]


@app.get("/items")
def list_items() -> list[Item]:
    return sorted(_DB.values(), key=lambda item: item.sku)


@app.put("/items/{sku}/stock")
def adjust_stock(
    sku: str,
    delta: Annotated[int | None, Query()] = None,
    payload: StockDelta | None = Body(default=None),
) -> Item:
    sku = sku.strip()
    if not sku:
        raise HTTPException(status_code=404, detail="Not found")

    if payload is not None:
        delta = payload.delta
    if delta is None:
        raise HTTPException(status_code=422, detail="delta is required")

    item = get_item(sku)
    if item.quantity + delta < 0:
        raise HTTPException(status_code=422, detail="Insufficient stock")
    item.quantity += delta
    return item
