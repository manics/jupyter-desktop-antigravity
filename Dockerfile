FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:43bef3f151a3ae004f9daeabe96f686c088c745476768f8a2a46b0c2d240ea58

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
