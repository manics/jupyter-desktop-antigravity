FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:e8c12ff8b075b5a6b95bd0c057fac1b31076426477f33f4b88c0c531e5796f5b

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
