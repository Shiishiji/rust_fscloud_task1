# syntax=docker/dockerfile:1.5.2

FROM rust:1.69-alpine3.16 as builder

RUN cd /usr && cargo new rust_fscloud_task1 --bin --vcs none

COPY --link Cargo.* /usr/rust_fscloud_task1

WORKDIR /usr/rust_fscloud_task1

RUN --mount=type=cache,target=/var/cache/apk --mount=type=cache,target=/var/lib/apk apk add libressl-dev build-base
RUN --mount=type=cache,target=/usr/rust_fscloud_task1/target cargo install --profile release --path .

COPY --link src ./src

RUN cargo install --profile release --path .

FROM debian:bullseye-slim

COPY --from=builder /usr/rust_fscloud_task1/target/release/ /usr/local/bin/

WORKDIR /usr/local/bin

CMD ["rust_fscloud_task1"]