# syntax=docker/dockerfile:1.5.2
FROM rust:1.69 as builder

RUN cd /usr && cargo new rust_fscloud_task1 --bin --vcs none

COPY --link Cargo.* /usr/rust_fscloud_task1

WORKDIR /usr/rust_fscloud_task1

RUN --mount=type=cache,target=/usr/rust_fscloud_task1/target cargo install --profile release --path .

COPY --link src ./src

RUN cargo install --profile release --path .

# syntax=docker/dockerfile:1.5.2
FROM debian:bullseye-slim

# Ballerina runtime distribution filename.
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Labels.
LABEL author="Damian Szopiński"
LABEL maintainer="shiishiji.dev@gmail.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="siguard/rust_fscloud_task1"
LABEL org.label-schema.description="Pollub task 1 for cloud laboratory"
LABEL org.label-schema.vcs-url="https://github.com/Shiishiji/rust_fscloud_task1"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -v ./var:/usr/local/bin/var -p 8080:8080 -d rust_fscloud_task1"

COPY --from=builder /usr/rust_fscloud_task1/target/release/ /usr/local/bin/

WORKDIR /usr/local/bin

VOLUME /usr/local/bin/var

EXPOSE 8080

CMD ["rust_fscloud_task1"]