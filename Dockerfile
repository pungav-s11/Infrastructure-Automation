# Base Image
FROM ubuntu:22.04

# Install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    vim

# Copy test file into container
COPY Test.txt /app/test.txt

# Set working directory
WORKDIR /app

# Default command
CMD ["cat", "test.txt"]