# I created a multistage dockerfile in order
# to have a lighter docker image which doesn't contain
# the source code and all the dependencies
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
# Copy the build from previous step
COPY --from=builder /app/build ./build
# Expose react port
EXPOSE 3000
RUN npm install serve
CMD ["npx", "serve", "build"]