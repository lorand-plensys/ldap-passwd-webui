FROM golang:1.19.1-alpine3.16 as builder

WORKDIR /app
COPY . ./
RUN go mod download
RUN go build -o /app/ ./...
RUN ls /app


FROM alpine:3.16.2 as resource

WORKDIR /app

COPY --from=builder /app/ldap-passwd-webui /app/ldap-passwd-webui
COPY --from=builder /app/static /app/static
COPY --from=builder /app/templates /app/templates
RUN chmod +x /app/ldap-passwd-webui

EXPOSE 8080

ENTRYPOINT [ "/app/ldap-passwd-webui" ]

FROM resource