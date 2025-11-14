FROM twinproduction/gatus:latest

# Create data directory for SQLite
RUN mkdir -p /data && chown 65534:65534 /data

# Copy the generated config
COPY config.yaml /config/config.yaml

# Set permissions
RUN chown -R 65534:65534 /config

# Use non-root user (already defined in base image)
USER 65534

# Expose port
EXPOSE 8080

# Volume for persistent data (optional for Cloud Run)
VOLUME ["/data"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Run Gatus
ENTRYPOINT ["/gatus"]
CMD ["--config", "/config/config.yaml"]
