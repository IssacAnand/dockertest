###############################################
# Base Image
###############################################
FROM python:3.11-slim as python-base


# locale setting
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PYTHONIOENCODING=utf-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PROD=True

RUN apt-get update -y \
    && apt-get install -y locales libgraphviz-dev \
    && apt-get install -y postgresql-client-13 libpq-dev \
    && apt-get install -y gcc g++ libffi-dev libgraphviz-dev \
    && apt-get install -y zlib1g poppler-utils libmagic-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/local/bin \
    && pip3 install --upgrade pi

# ENV PYTHONUNBUFFERED=1 \
#     PYTHONDONTWRITEBYTECODE=1 \
#     POETRY_VERSION=1.5.0 \
#     POETRY_HOME="./" \
#     POETRY_VIRTUALENVS_IN_PROJECT=true \
#     POETRY_NO_INTERACTION=1 \
#     PYSETUP_PATH="./" \
#     VENV_PATH="./"

# prepend poetry and venv to path
#ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

###############################################
# Builder Image
###############################################
# RUN apt-get update \
#     && apt-get install --no-install-recommends -y \
#     curl \
#     build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
#RUN curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master

# copy project requirement files here to ensure they will be cached.
# $PYSETUP_PATH is the root directory. Further instructions will start from this director


# Docker will cache layers if nothing changes
# In docker -> Install dependices first so they will be cached
# WORKDIR /$PYSETUP_PATH
RUN mkdir /app
WORKDIR /app
COPY pyproject.toml poetry.lock ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
#RUN poetry install

#COPY fresh .${POETRY_HOME}

# Install python packages
RUN pip3 install poetry
RUN poetry config virtualenvs.in-project true  \
    && poetry run pip install -U setuptools==57.0.0
RUN poetry install

COPY src src

COPY docker docker

RUN chmod a+x ./docker/*.sh


EXPOSE 5000

CMD ["python", "manage.py", "runserver"]

#######################################