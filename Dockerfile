# Zoo Computer — Vite SPA build, served static via hanzoai/spa.
#
# Build stage compiles the Vite app to dist/; runtime stage serves the
# static output on :3000 via ghcr.io/hanzoai/spa (the canonical Zoo/Hanzo
# static server, same as zooai/exchange).

# ─── Build stage ─────────────────────────────────────────────────────
FROM node:22-alpine AS build
RUN apk add --no-cache git
WORKDIR /app

# Manifests first for layer caching.
COPY package.json package-lock.json* ./
RUN npm ci --no-audit --no-fund

# Source + build.
COPY . .
RUN npm run build

# ─── Runtime: static SPA via hanzoai/spa (serves /public on :3000) ────
FROM ghcr.io/hanzoai/spa:1.2.0
COPY --from=build /app/dist /public
