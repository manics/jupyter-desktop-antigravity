FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:954b9215f9f47d9e0c3ea87934d47d8e8327e9cd7301485c7bcdd08777483641

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
