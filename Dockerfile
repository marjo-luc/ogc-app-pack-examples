# Use miniconda as the base image with the specified version.
FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# Copy application files to the /opt directory.
COPY print_message.py /app/print_message.py

# Assign execute permissions to the scripts.
RUN chmod +x /app/print_message.py
