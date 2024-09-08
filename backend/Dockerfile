FROM python:3.12-slim-bullseye

WORKDIR /code
COPY . /code/

RUN apt-get update && \
apt-get install -y freetds-dev locales bash gcc git
RUN pip install -r requirements.txt

ENV PATH="/root/.local/bin:$PATH"

RUN pytest

LABEL VERSION="0.1.0"

EXPOSE 8080

ENTRYPOINT ["uvicorn", "project.hospital_management.main:app"]
CMD ["--reload", "--host", "0.0.0.0", "--port", "8080"]
