FROM python:3.8

RUN apt-get update && apt-get install -y \
  sudo \
  wget \
  vim

WORKDIR /opt

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
  rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

RUN pip install --upgrade pip && \
  conda update -n base -c defaults conda

COPY ./configs /app/configs

COPY ./ldm /app/ldm

COPY ./setup.py /app/setup.py

COPY ./main.py /app/main.py

WORKDIR /app

COPY ./environment.yaml /app/environment.yaml

RUN conda env create -f environment.yaml

RUN conda init bash

RUN echo "conda activate ldm" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV ldm && \
  PATH /opt/conda/envs/ldm/bin:$PATH

CMD ["/bin/bash"]
