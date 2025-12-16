# Frontend Dockerfile - Multi-stage build with Nginx
FROM node:20-alpine AS builder

WORKDIR /app

# Copy frontend dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source
COPY frontend ./

# Disable telemetry during build
ENV NEXT_TELEMETRY_DISABLED=1

# Build the static export
RUN npm run build

# Production stage with Nginx
FROM nginx:alpine

# Install envsubst (part of gettext)
RUN apk add --no-cache gettext

# Copy built static files to Nginx
COPY --from=builder /app/out /usr/share/nginx/html

# Copy config template for runtime configuration
COPY docker/config.js.template /usr/share/nginx/html/config.js.template

# Copy custom Nginx config as template (will be processed at startup)
COPY docker/nginx.conf.template /etc/nginx/conf.d/default.conf.template

# Copy entrypoint script
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default backend URL (empty = use docker-compose service name "backend")
ENV BACKEND_URL=""

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
