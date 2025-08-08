@app.get("/")
def home():
    return {"message": "Hello from CI/CD!"}
