FROM python:3.11-slim

# Install runtime dependencies for sqlmap + git for cloning
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone sqlmap at build time so it lands at the path _SQLMAP_DIR resolves to
RUN git clone --depth=1 https://github.com/sqlmapproject/sqlmap.git \
    /app/sqlmap/sqlmap-master

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy bot source and data directory skeleton
COPY oggy_dumper.py .
RUN mkdir -p /app/data

# Render / Cloud Run injects PORT; default to 3000 for local runs
ENV PORT=3000

CMD ["python", "oggy_dumper.py"]
