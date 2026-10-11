import pytest
from fastapi.testclient import TestClient

from src.main import _DB, app

client = TestClient(app)


@pytest.fixture(autouse=True)
def clean():
    _DB.clear()


def test_health():
    assert client.get("/health").json() == {"status": "ok"}


def test_create_and_get():
    r = client.post("/items", json={"sku": "A1", "name": "Mug", "quantity": 5})
    assert r.status_code == 201
    assert client.get("/items/A1").json()["quantity"] == 5


def test_duplicate_sku():
    body = {"sku": "A1", "name": "Mug", "quantity": 5}
    client.post("/items", json=body)
    assert client.post("/items", json=body).status_code == 409


def test_stock_cannot_go_negative():
    client.post("/items", json={"sku": "A1", "name": "Mug", "quantity": 1})
    assert client.put("/items/A1/stock", params={"delta": -2}).status_code == 422


def test_not_found():
    assert client.get("/items/nope").status_code == 404
