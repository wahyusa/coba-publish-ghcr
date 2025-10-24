# syntax=docker/dockerfile:1
FROM golang:1.25 AS builder
WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /out/app .

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /out/app /app

USER nonroot:nonroot
ENTRYPOINT ["/app"]
