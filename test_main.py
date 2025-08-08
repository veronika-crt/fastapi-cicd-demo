import pytest
from fastapi.testclient import TestClient

from main import app

def test_example():
    assert 1 + 1 == 2



@pytest.fixture(scope="module")
def client() -> TestClient:
    """
    Create a TestClient for the FastAPI app.
    This fixture has a 'module' scope, so the client is created once per test module.
    """
    with TestClient(app) as c:
        yield c


def test_read_root(client: TestClient):
    """Test the root endpoint ('/')."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "CI/CD FastAPI demo running!"}
