FROM debian:12
SHELL ["/bin/bash", "-c"]

RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget bzip2 ca-certificates curl git  build-essential

RUN wget --quiet https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/miniforge && \
    rm /tmp/miniforge.sh

ENV PATH="/opt/miniforge/bin:${PATH}"

# Now conda commands will work in Docker's build steps:
RUN conda update -n base conda -y
RUN conda install -n base ipykernel --update-deps --force-reinstall
RUN /opt/miniforge/bin/pip install numpy matplotlib pandas imageio_ffmpeg ffmpeg-python pyinstrument rich marimo dask parquet
# Create non-root user
RUN useradd -m devuser
USER devuser
WORKDIR /home/devuser

RUN conda init
# Make devuser's shell auto-activate conda base
RUN echo "conda activate base" >> /home/devuser/.bashrc

CMD ["/bin/bash", "-l"]


