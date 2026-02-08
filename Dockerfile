FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:59b30a69b8afc268906ebc6db5538a093879801e2c49474b7830aa48206840cb

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
