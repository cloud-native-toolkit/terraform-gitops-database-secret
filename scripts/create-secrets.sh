#!/usr/bin/env bash

NAMESPACE="$1"
SECRET_NAME="$2"
DEST_DIR="$3"

export PATH="${BIN_DIR}:${PATH}"

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

if [[ -z "${DATABASE_USERNAME}" ]] || [[ -z "${DATABASE_PASSWORD}" ]] || [[ -z "${DATABASE_HOST}" ]] || [[ -z "${DATABASE_PORT}" ]] || [[ -z "${DATABASE_NAME}" ]]; then
  echo "DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_HOST, DATABASE_PORT, and DATABASE_NAME are required as environment variables"
  exit 1
fi

if [[ -z "${HOST_KEY}" ]]; then
  HOST_KEY="host"
fi

if [[ -z "${PORT_KEY}" ]]; then
  PORT_KEY="port"
fi

if [[ -z "${DATABASE_NAME_KEY}" ]]; then
  DATABASE_NAME_KEY="database"
fi

if [[ -z "${USERNAME_KEY}" ]]; then
  USERNAME_KEY="username"
fi

if [[ -z "${PASSWORD_KEY}" ]]; then
  PASSWORD_KEY="password"
fi

kubectl create secret generic "${SECRET_NAME}" \
  --from-literal="${HOST_KEY}=${DATABASE_HOST}" \
  --from-literal="${PORT_KEY}=${DATABASE_PORT}" \
  --from-literal="${DATABASE_NAME_KEY}=${DATABASE_NAME}" \
  --from-literal="${USERNAME_KEY}=${DATABASE_USERNAME}" \
  --from-literal="${PASSWORD_KEY}=${DATABASE_PASSWORD}" \
  -n "${NAMESPACE}" \
  --dry-run=client \
  --output=yaml > "${DEST_DIR}/${SECRET_NAME}.yaml"
