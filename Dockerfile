FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:763c44d8df3cd8063a82ee99e6b4b31525aeb335732b8e7084d5cc0d9c5f2d64

USER root

COPY install.sh /root/
RUN /root/install.sh && \
    rm -rf /var/lib/apt/lists/*

# Silence ALSA warnings by creating a dummy configuration
RUN printf 'pcm.!default { type null } \nctl.!default { type null }\n' > /etc/asound.conf

USER $NB_USER

RUN mamba install --yes --freeze-installed \
        go-cgo \
        kubernetes-client \
        kubernetes-helm \
        stern \
        && \
    mamba clean --all

COPY --chown=$NB_UID:$NB_GID antigravity.desktop "$HOME_TEMPLATE_DIR/Desktop"
