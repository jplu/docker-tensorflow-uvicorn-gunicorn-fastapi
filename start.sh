#! /usr/bin/env sh
set -e

if [ -f /app/app/main.py ]; then
    DEFAULT_MODULE_NAME=app.main
elif [ -f /app/main.py ]; then
    DEFAULT_MODULE_NAME=main
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-app}
export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}

if [ -f /app/gunicorn_conf.py ]; then
    DEFAULT_GUNICORN_CONF=/app/gunicorn_conf.py
elif [ -f /app/app/gunicorn_conf.py ]; then
    DEFAULT_GUNICORN_CONF=/app/app/gunicorn_conf.py
else
    DEFAULT_GUNICORN_CONF=/gunicorn_conf.py
fi
export GUNICORN_CONF=${GUNICORN_CONF:-$DEFAULT_GUNICORN_CONF}

#HOST=${HOST:-0.0.0.0}
#PORT=${PORT:-80}
#LOG_LEVEL=${LOG_LEVEL:-info}

# Start Uvicorn with live reload
#exec uvicorn --reload --host $HOST --port $PORT --log-level $LOG_LEVEL "$APP_MODULE"
exec gunicorn -k uvicorn.workers.UvicornWorker -c "$GUNICORN_CONF" "$APP_MODULE"
