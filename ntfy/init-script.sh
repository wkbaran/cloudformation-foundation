#!/bin/sh
# Check if user already exists to avoid recreation on container restart
. .env
if ! ntfy user list 2>&1 | grep -q "${ADMINUSER}"; then
    NTFY_PASSWORD=${ADMINPASS} ntfy user add --role=admin ${ADMINUSER}
    echo "User 'username' created"
else
    echo "User 'username' already exists"
fi
