from fastapi.testclient import TestClient

from project.shared.entities.entities import Hospital

def test_get_all_sectors_success(client: TestClient, get_hospital: Hospital):
    response = client.get(f"/sector/{get_hospital.tax_number}")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
def test_create_sector(client: TestClient, get_hospital: Hospital):
    response = client.post(f"/sector/{get_hospital.tax_number}", json={"name": "Centro Cirúrgico"})
    assert response.status_code == 201
    assert 'name' in response.json()
    
def test_get_sector_by_id(client: TestClient, get_hospital: Hospital, create_records):
    response = client.get(f"/sector/{get_hospital.tax_number}/1")
    assert response.status_code == 200
    
def test_update_sector(client: TestClient, get_hospital: Hospital, create_records):
    response = client.put(f"/sector/{get_hospital.tax_number}/1", json={'name': 'testepapai'})
    assert response.status_code == 200
    

def test_delete_sector(client: TestClient, get_hospital: Hospital, create_records):
    client.delete(f"/bed/{get_hospital.tax_number}/1")
    client.delete(f"/bed/{get_hospital.tax_number}/2")
    response = client.delete(f"/sector/{get_hospital.tax_number}/1")
    assert response.status_code == 204
    