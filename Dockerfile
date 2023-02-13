FROM registry.fedoraproject.org/fedora-minimal:37 as build
LABEL maintainer="Simon Krenger <simon@krenger.ch>"

WORKDIR /build/
RUN microdnf install -y golang
COPY main.go .
COPY go.mod .
# http://blog.wrouesnel.com/articles/Totally%20static%20Go%20builds/
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' .

FROM scratch
LABEL maintainer="Simon Krenger <simon@krenger.ch>"
LABEL description="Small container for the Serverless TAM Webinar in February 2023"
WORKDIR /
COPY --from=0 /build/webinar-serverless-container server

ENV GIN_MODE release
ENV PORT 8080
EXPOSE $PORT
USER 1001
CMD ["./server"]

