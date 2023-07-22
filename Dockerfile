####################################################################################################
## Builder
####################################################################################################
FROM rust:alpine AS builder

# USER root

RUN apk add --no-cache musl-dev curl
# apk add github-cli

WORKDIR /libreddit

COPY . .


# Make the script executable
# RUN chmod +x extract_download_url.sh


run response=$(curl -s "https://api.github.com/repos/libreddit/libreddit/releases/latest") && \
    download_urls=$(echo "$response" | grep -o -E "https://github.com/libreddit/libreddit/releases/download/[^/]+/libreddit") && \
    selected_url=$(echo "$download_urls" | head -n 1) && \
    echo "Download URL: $selected_url" && \
    curl -L "$selected_url" -o /libreddit/libreddit && \
    chmod +x /libreddit/libreddit
##########################################



# RUN gh auth login --hostname github.com
# RUN gh release download --repo libreddit/libreddit --pattern 'libreddit'

####################################################################################################
## Final image
####################################################################################################
FROM alpine:latest

# Import ca-certificates from builder
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Copy our build
COPY --from=builder /libreddit/libreddit /usr/local/bin/libreddit

# Use an unprivileged user.
RUN adduser --home /nonexistent --no-create-home --disabled-password libreddit
USER libreddit

# Tell Docker to expose port 8080
EXPOSE 8080

# Run a healthcheck every minute to make sure Libreddit is functional
HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider --q http://localhost:8080/settings || exit 1

CMD ["libreddit"]
####################################################################################################
## Builder
####################################################################################################
FROM rust:alpine AS builder

# USER root

RUN apk add --no-cache musl-dev curl
# apk add github-cli

WORKDIR /libreddit

COPY . .


# Make the script executable
# RUN chmod +x extract_download_url.sh


run response=$(curl -s "https://api.github.com/repos/libreddit/libreddit/releases/latest") && \
    download_urls=$(echo "$response" | grep -o -E "https://github.com/libreddit/libreddit/releases/download/[^/]+/libreddit") && \
    selected_url=$(echo "$download_urls" | head -n 1) && \
    echo "Download URL: $selected_url" && \
    curl -L "$selected_url" -o /libreddit/libreddit && \
    chmod +x /libreddit/libreddit
##########################################



# RUN gh auth login --hostname github.com
# RUN gh release download --repo libreddit/libreddit --pattern 'libreddit'

####################################################################################################
## Final image
####################################################################################################
FROM alpine:latest

# Import ca-certificates from builder
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Copy our build
COPY --from=builder /libreddit/libreddit /usr/local/bin/libreddit

# Use an unprivileged user.
RUN adduser --home /nonexistent --no-create-home --disabled-password libreddit
USER libreddit

# Tell Docker to expose port 8080
EXPOSE 8080

# Run a healthcheck every minute to make sure Libreddit is functional
HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider --q http://localhost:8080/settings || exit 1

CMD ["libreddit"]
