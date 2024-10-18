# Use the official Node.js image as the base
FROM node:20.18.0-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy the entrypoint script and make it executable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Generate Prisma Client
RUN npx prisma generate

# Expose port 3030
EXPOSE 3030

# Use the custom entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
