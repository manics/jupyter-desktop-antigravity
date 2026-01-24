FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:fc3ac77e66d80f7606be20d9a96a7f926e60b6f5281271bad4ae22b13728628e

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
