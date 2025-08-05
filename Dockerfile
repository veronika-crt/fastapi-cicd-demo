# Stage 1: Build stage - where we install dependencies into a wheelhouse
FROM python:3.11-slim as builder

# Set the working directory
WORKDIR /app

# Set environment variables to improve Python performance in Docker
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copy and install dependencies
COPY requirements.txt .
# The --no-cache-dir flag is a best practice for Docker builds
RUN pip install --no-cache-dir --upgrade pip
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Final stage - the lean, production-ready image
FROM python:3.11-slim

WORKDIR /app

# Copy the pre-built wheels and application code from the builder stage
COPY --from=builder /app/wheels /wheels
COPY requirements.txt .
COPY ./main.py .

# Install the dependencies from the wheels, then clean up
RUN pip install --no-cache /wheels/* && rm -rf /wheels

# Expose the port the app runs on and define the run command
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]