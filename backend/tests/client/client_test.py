from fastapi.testclient import TestClient
from project.shared.entities.entities import Hospital

def test_signup(client: TestClient, get_hospital: Hospital):
    user = {"name": "admin", "email": "admi7@admin.com", "password": "mypassword2", 'phone': '71984659415', 'tax_number': '42445507049', "hospital_unique_code": get_hospital.unique_code}
    response = client.post("/client/signup", json=user)
    assert response.status_code == 201 


def test_login(client: TestClient):
    user = {"email": "carlos.admin@example.com", "password": "admin123"}
    response = client.post("/client/login", json=user)
    assert response.status_code == 200
    assert "sub" in response.json()
    
def test_update_client(client: TestClient):
    user = {"name": "admin", "password": "mypassword2", "email": "admi7@admin.com", "phone": "71984659415", "tax_number": "42445507049"}
    response = client.put("/client", json=user)
    assert response.status_code == 200
    assert "name" in response.json()
    