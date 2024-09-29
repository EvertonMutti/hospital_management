from fastapi.testclient import TestClient



TestClient.fixture
def client():
    return TestClient(TestClient.main)


def test_create_bed(client: TestClient):

    bed_data = {
        "name": "Bed 1",
        "status": "available",
        "sector": "ICU"
    }


    response = client.post("/beds", json=bed_data)


    assert response.status_code == 201

    response_data = response.json()
    assert response_data["name"] == "Bed 1"
    assert response_data["status"] == "available"
    assert response_data["sector"] == "ICU"


def test_update_bed(client: TestClient):

    bed_update_data = {
        "name": "Updated Bed",
        "status": "occupied",
        "sector": "Surgery"
    }

    response = client.put("/bed/1", json=bed_update_data)

    # Verifica se o código de resposta é 200 (OK)
    assert response.status_code == 200

    # Verifica se os dados retornados foram atualizados corretamente
    response_data = response.json()
    assert response_data["name"] == "Updated Bed"
    assert response_data["status"] == "occupied"
    assert response_data["sector"] == "Surgery"


def test_delete_bed(client: TestClient):
    # Deletando o leito com ID 1
    response = client.delete("/beds/1")

    # Verifica se o código de resposta é 204 (No Content)
    assert response.status_code == 204


def test_get_bed(client: TestClient):
    # Obtendo os detalhes de um leito com ID 1
    response = client.get("/beds/1")

    # Verifica se o código de resposta é 200 (OK)
    assert response.status_code == 200

    # Verifica se os dados retornados estão corretos
    response_data = response.json()
    assert "name" in response_data
    assert "status" in response_data
    assert "sector" in response_data
