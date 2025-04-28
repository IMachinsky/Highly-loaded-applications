FROM python:3.9-slim

RUN apt-get update && apt-get install -y net-tools lsof && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN pip install flask redis
CMD ["python", "app.py"]