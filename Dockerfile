FROM golang:alpine AS agent-builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY cmd ./cmd
COPY internal ./internal

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/openclaw-agent ./cmd/openclaw-agent


FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Shanghai

LABEL shm_size="1gb"

EXPOSE 3000 3001

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    python3 \
    python3-pip \
    python3-pandas \
    python3-numpy \
    python3-matplotlib \
    python3-seaborn \
    python3-requests \
    pandoc \
    libpoppler-cpp-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
  && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -y nodejs \
  && python3 -m pip install --no-cache-dir \
    python-docx==1.2.0 \
    pdfplumber==0.11.9 \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@2026.3.24
RUN npm install -g clawhub@latest

COPY defaults-template/.openclaw /defaults/.openclaw
COPY defaults-template/.config /defaults/.config
COPY config/openclaw-agent /defaults/openclaw-agent
COPY scripts/99-openclaw-sync /custom-cont-init.d/99-openclaw-sync
COPY --from=agent-builder /out/openclaw-agent /usr/local/bin/openclaw-agent
COPY scripts/openclaw-agent-run /etc/services.d/openclaw-agent/run
COPY scripts/openclaw-agent-finish /etc/services.d/openclaw-agent/finish

RUN sed -i 's/\r$//' /custom-cont-init.d/99-openclaw-sync \
  && sed -i 's/\r$//' /etc/services.d/openclaw-agent/run \
  && sed -i 's/\r$//' /etc/services.d/openclaw-agent/finish \
  && chmod +x /custom-cont-init.d/99-openclaw-sync \
  && chmod +x /etc/services.d/openclaw-agent/run \
  && chmod +x /etc/services.d/openclaw-agent/finish \
  && chmod +x /usr/local/bin/openclaw-agent \
  && chown -R abc:abc /defaults/.openclaw \
  && chown -R abc:abc /defaults/.config \
  && mkdir -p /var/lib/openclaw-agent /var/log/openclaw-agent /etc/openclaw-agent
