FROM alpine:latest

# Update
RUN apk update

# Install packages
RUN apk add rsync openssh-client

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
