FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies for python-magic
RUN apt-get update && apt-get install -y \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY src/requirements.txt .

# Install requirements and additional dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir gunicorn

# Copy application files
COPY src/ .

# Create the database directory
RUN mkdir -p database db/pictures db/downloads

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV FLASK_ENV=production
ENV PYTHONPATH=/app

# Expose the port
EXPOSE 8000

# Run gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi:application"]
