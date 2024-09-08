from fastapi.testclient import TestClient


def test_signup(client: TestClient):
    user = {"name": "admin", "email": "admi7@admin.com", "password": "mypassword2"}
    response = client.post("/client/signup", json=user)
    assert response.status_code == 201 


def test_login(client: TestClient):
    user = {"email": "admin@admin.com", "password": "mypassword"}
    response = client.post("/client/login", json=user)
    assert response.status_code == 200
    assert "sub" in response.json()
    