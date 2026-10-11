"""Acme Retail Inventory Management System (IMS) - reference application."""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="Acme IMS", version="1.0.0")


class Item(BaseModel):
    sku: str = Field(min_length=1, max_length=64)
    name: str = Field(min_length=1, max_length=200)
    quantity: int = Field(ge=0)


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
    if sku not in _DB:
        raise HTTPException(status_code=404, detail="Not found")
    return _DB[sku]


@app.get("/items")
def list_items() -> list[Item]:
    return list(_DB.values())


@app.put("/items/{sku}/stock")
def adjust_stock(sku: str, delta: int) -> Item:
    item = get_item(sku)
    if item.quantity + delta < 0:
        raise HTTPException(status_code=422, detail="Insufficient stock")
    item.quantity += delta
    return item
