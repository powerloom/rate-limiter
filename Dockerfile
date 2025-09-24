FROM python:3.10.16-slim

RUN apt-get update && apt-get install -y \
    build-essential git\
    && rm -rf /var/lib/apt/lists/*

# Install the PM2 process manager for Node.js
RUN pip install poetry

# Set working directory
WORKDIR /app

# Set default rate limit
ENV DEFAULT_RATE_LIMIT=1000
ENV HOST=0.0.0.0
ENV PORT=8000

# Copy the application's dependencies files
COPY poetry.lock pyproject.toml ./

# Install the Python dependencies
RUN poetry install --no-root

# Copy the rest of the application's files
COPY . .

# Default command to run the application (uses env HOST and PORT)
CMD ["sh", "-c", "poetry run uvicorn app:app --host ${HOST} --port ${PORT}"]
