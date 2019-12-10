FROM docker.io/ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
#Can not use /temp on our cluster
WORKDIR /home
COPY . /home/install/

# Update and create base image
RUN apt-get update -y &&\
    apt-get install apt-utils -y &&\
    apt-get install -y wget unzip bzip2 ssh gcc g++ git &&\
    apt-get clean

# Install Anaconda
SHELL ["/bin/bash", "-c"]
RUN wget -q https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh &&\
    bash Anaconda3-2019.03-Linux-x86_64.sh -b -p /home/anaconda3
ENV PATH="/home/anaconda3/bin:${PATH}"
RUN conda update -y conda &&\
    conda update -y conda-build

# Install cooltools environment
RUN conda env create -f /home/install/cooltools.yml 

# Install bioframe, cooltools and pairlib as well as our own NGS library
RUN source activate cooltools &&\
    pip install git+git://github.com/mirnylab/bioframe@40ca346f8726cf809a16fca4df21298f7c096dc3 &&\
    pip install git+git://github.com/mirnylab/cooltools@26b885356e5fd81dd6f34ef688edc45a020ca9d0 &&\
    pip install git+git://github.com/mirnylab/pairlib@663eeb52405677dfd3117e79a1b31b7308b4bd70 &&\
    pip install git+git://github.com/gerlichlab/NGS.git
