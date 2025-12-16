#!/bin/sh

# Default backend URL for docker-compose (uses service name)
# Can be overridden by BACKEND_URL environment variable
if [ -z "$BACKEND_URL" ]; then
    # In docker-compose, backend service is accessible via hostname "backend"
    export BACKEND_PROXY_URL="http://backend:3001"
else
    export BACKEND_PROXY_URL="$BACKEND_URL"
fi

echo "[entrypoint] Backend proxy URL: $BACKEND_PROXY_URL"

# Replace environment variables in config.js template
envsubst < /usr/share/nginx/html/config.js.template > /usr/share/nginx/html/config.js

# Replace environment variables in nginx config
# Only substitute BACKEND_PROXY_URL, preserve nginx variables like $uri
envsubst '${BACKEND_PROXY_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g 'daemon off;'
