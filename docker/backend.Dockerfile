# Backend Dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy backend dependencies
COPY backend/package*.json ./
RUN npm install --omit=dev

# Copy backend source
COPY backend ./

# Create uploads directory
RUN mkdir -p /app/uploads

# Security: Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs && \
    chown -R nodejs:nodejs /app

# Set production environment
ENV NODE_ENV=production
ENV PORT=3001

# Switch to non-root user
USER nodejs

EXPOSE 3001

CMD ["npm", "start"]
