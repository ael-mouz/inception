FROM debian:bullseye-slim

# Copy the installation script
COPY install-wordpress.sh /install-wordpress.sh

# Make the script executable
RUN chmod +x /install-wordpress.sh

# Execute the installation script
RUN /install-wordpress.sh

# Expose ports for Nginx
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
