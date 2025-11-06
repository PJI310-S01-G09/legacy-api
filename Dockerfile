# Etapa de compilação (instala dependências com build-essential)
FROM python:3.8-slim-bullseye AS compiler

ENV PYTHONUNBUFFERED=1

WORKDIR /app/

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

# Etapa de execução (mais leve)
FROM python:3.8-slim-bullseye AS runner

WORKDIR /app/

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=compiler /usr/local /usr/local
COPY . /app/

CMD ["./start_server.sh"]
