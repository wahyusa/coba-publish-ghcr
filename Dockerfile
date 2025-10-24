# --- Stage 1: Builder (for compilation) ---
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Statically link the binary for portability
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/server ./main.go

# --- Stage 2: Final Image (minimal runtime) ---
FROM alpine:latest
# Or, for absolute smallest image: FROM scratch

WORKDIR /app
# Copy only the compiled binary
COPY --from=builder /app/server .
EXPOSE 8080
CMD ["/app/server"]
