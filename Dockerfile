FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:18fb807c65235027a01304393fcb46c708f4d39c6ee1994e76ae329d2424671e

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
