FROM alpine:3.20

# Optimization: Use Aliyun mirror for faster/stable builds in China (+08:00)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 1. Install basic tools for demonstration
# Removed 'neofetch' and 'mc' to reduce build failure risks
RUN apk add --no-cache \
    bash \
    htop \
    vim \
    nano \
    git \
    curl \
    wget \
    openssh-server \
    python3 \
    shadow

# 2. Configure SSH Service
RUN mkdir /var/run/sshd
# Disable root login for security
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
# Enable password auth
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

# 3. Create non-privileged demo user
RUN adduser -D -s /bin/bash demo && \
    echo "demo:demo" | chpasswd

# 4. Honeypot Setup: Load Simulator
COPY docker/honeypot/simulator.py /opt/simulator.py
COPY docker/honeypot/start.sh /start.sh
RUN chmod +x /start.sh

# 5. Generate SSH host keys
RUN ssh-keygen -A

EXPOSE 22

CMD ["/start.sh"]
