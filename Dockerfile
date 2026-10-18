FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:55c9e8cac166cc1386d3e12932cf7d2f00ab1e051823bdaf780134cee2f6f9ff

USER root

COPY install1.sh /root/
RUN /root/install1.sh && \
    rm -rf /var/lib/apt/lists/*

COPY install2.sh /root/
RUN /root/install2.sh

# Silence ALSA warnings by creating a dummy configuration
RUN printf 'pcm.!default { type null } \nctl.!default { type null }\n' > /etc/asound.conf

USER $NB_USER

# RUN mamba install --yes --freeze-installed \
#         go-cgo \
#         kubernetes-client \
#         kubernetes-helm \
#         stern \
#         && \
#     mamba clean --all

COPY --chown=$NB_UID:$NB_GID antigravity*.desktop "$HOME_TEMPLATE_DIR/Desktop"
