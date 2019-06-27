FROM docker.io/ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /home
COPY . /home/install/

# Update and create base image
RUN apt-get update -y &&\
    apt-get install apt-utils -y &&\
    apt-get install -y wget &&\
    apt-get install -y unzip &&\
    apt-get install -y bzip2
# Install Anaconda
RUN wget -q https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh &&\
    bash Anaconda3-2019.03-Linux-x86_64.sh -b -p /root/anaconda3
ENV PATH="/root/anaconda3/bin:${PATH}"
RUN conda update -y conda &&\
    conda update -y conda-build &&\
    conda init

# Install cooltools environment
RUN conda env create -f /home/install/cooltools.yml &&\
   conda activate cooltools
# Install bioframe, cooltools and pairlib
#RUN 