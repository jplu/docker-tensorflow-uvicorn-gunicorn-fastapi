FROM tensorflow/tensorflow:1.13.1-py3

LABEL maintainer="Julien Plu <julien.plu@schibsted.com>"

RUN apt update && \
    apt install software-properties-common -y && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update && \
    apt install python3.7 python3.7-dev -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /usr/local/bin/python && \
    ln -s /usr/bin/python3.7 /usr/local/bin/python && \
    pip freeze > requirements.txt && \
    python3.7 -m pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U -r requirements.txt && \
    rm requirements.txt && \
    pip install --no-cache-dir -U uvicorn gunicorn fastapi 

COPY ./gunicorn_conf.py /gunicorn_conf.py
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 80

CMD ["/start.sh"]
