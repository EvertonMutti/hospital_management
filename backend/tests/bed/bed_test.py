from fastapi.testclient import TestClient

from project.shared.entities.entities import Hospital

def test_get_beds_grouped_by_sector(client: TestClient, get_hospital: Hospital):
    response = client.get(f"/bed/{get_hospital.tax_number}")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    
def test_create_bed(client: TestClient, get_hospital: Hospital, create_records):
    response = client.post(f"/bed/{get_hospital.tax_number}", json={"bed_number": "C003", "sector_id": 1})
    assert response.status_code == 201
    assert 'bed_number' in response.json()
    
def test_get_count_by_tax_number(client: TestClient, get_hospital: Hospital, create_records):
    response = client.get(f"/bed/status/count/{get_hospital.tax_number}")
    assert response.status_code == 200
    
    
def test_get_bed_by_id(client: TestClient, get_hospital: Hospital, create_records):
    response = client.get(f"/bed/{get_hospital.tax_number}/1")
    assert response.status_code == 200
    
def test_update_bed(client: TestClient, get_hospital: Hospital, create_records):
    response = client.put(f"/bed/{get_hospital.tax_number}/1", json={'bed_number': 'testepapai', 'sector_id': 1, 'status': 'FREE'})
    assert response.status_code == 200
    
def test_delete_bed(client: TestClient, get_hospital: Hospital, create_records):
    response = client.delete(f"/bed/{get_hospital.tax_number}/1")
    assert response.status_code == 204
    