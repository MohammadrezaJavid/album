########################### Stage one build go app ###########################
FROM golang:1.21rc2-alpine3.18 AS builder

WORKDIR /app

COPY go.*           ./
COPY *.go           ./
COPY api/           ./api
COPY config/        ./config
COPY database/      ./database
COPY migrations/    ./migrations

RUN go mod tidy && go mod download

RUN CGO_ENABLE=0 GOOS=linux GOARCH=amd64 -ldflags="-w -s" go build main.go

########################### Stage two create image ###########################

FROM scratch

COPY --from=builder /app/main /

EXPOSE 80

CMD [ "/main" ]