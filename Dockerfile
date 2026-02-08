FROM python:3.10-slim-bookworm

RUN addgroup --system app && adduser --system --ingroup app app \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade "wheel>=0.46.2" "jaraco.context>=6.1.0" \
    && pip install --no-cache-dir -r requirements.txt \
    && find /usr -type d -name "wheel-0.45.1.dist-info" -prune -exec rm -rf {} + \
    && find /usr -type d -name "jaraco.context-5.3.0.dist-info" -prune -exec rm -rf {} + \
    && pip install --no-cache-dir --upgrade "wheel==0.46.3" "jaraco.context==6.1.0" \
    && pip check

COPY app ./app

USER app

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
