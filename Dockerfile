FROM node:16-alpine 
WORKDIR /app

CMD [ "npx", "start"]

COPY package*.json ./

# Install dependencies using the versions in lockfile
RUN npm ci

# Copy the rest of the application code
COPY public ./public
COPY src ./src
# Build the app
RUN npm run build

# Expose a port
EXPOSE 3000

# Start the application
CMD ["npx", "serve", "build"]