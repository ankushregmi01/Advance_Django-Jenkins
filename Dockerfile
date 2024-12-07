# FROM python AS builder
# EXPOSE 8000
# WORKDIR /mysite
# COPY requirements.txt /mysite
# RUN pip install --upgrade pip
# RUN pip install --upgrade pip setuptools wheel
# RUN pip install -r requirements.txt
# COPY . /mysite
# ENTRYPOINT ["python"]
# CMD ["manage.py", "runserver", "0.0.0.0:8000"]


# Use a smaller base image and install dependencies in one layer
FROM python:3.11-slim AS base

# Set environment variables to avoid creating .pyc files and buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
WORKDIR /mysite
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends gcc \
    && pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && apt-get remove -y gcc \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the application code
COPY . .

# Expose the application port
EXPOSE 8000

# Set entry point
ENTRYPOINT ["python"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
