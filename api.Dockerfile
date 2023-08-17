FROM python:3.10.8-alpine AS build

ENV PYTHONDONTWRITEBYTECODE 1 \
    PYTHONUNBUFFERED 1 \

ARG POETRY_VERSION=1.1.13

RUN apk update \
    && apk upgrade \
    && apk --no-cache add curl \
    && curl -sSL https://install.python-poetry.org | POETRY_VERSION=$POETRY_VERSION python3 -

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /usr/app

COPY pyproject.toml ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi \
    && apk del curl \
    && rm -rf ~/.local/share/pypoetry

COPY api.py .

EXPOSE 5000

CMD [ "python3", "api.py"]

