FROM node:16-alpine as builder
WORKDIR /app
# Copy the package for the dependencies
COPY package*.json ./
# Install dependencies using the versions in lockfile
RUN npm ci
# Copy the rest of the application code
COPY public ./public
COPY src ./src
# Build the app
RUN npm run build

FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app/build ./build
# Expose react port
EXPOSE 3000
CMD ["npx", "serve", "build"]