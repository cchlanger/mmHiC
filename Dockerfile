FROM docker.io/ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
#Can not use /temp on our cluster
WORKDIR /temp
COPY . /temp/install/
ENV LANG C.UTF-8  
ENV LC_ALL C.UTF-8

# Update and create base image
RUN apt-get update -y &&\
    apt-get install apt-utils -y &&\
    apt-get install -y file bzip2  gcc g++ git make ssh unzip wget &&\
    apt-get clean

# Install Anaconda
SHELL ["/bin/bash", "-c"]
RUN wget -q https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh &&\
    bash Anaconda3-2019.03-Linux-x86_64.sh -b -p /home/anaconda3
ENV PATH="/home/anaconda3/bin:${PATH}"
RUN conda update -y conda &&\
    conda update -y conda-build

#Install OnTAD
RUN cd /opt && git clone https://github.com/anlin00007/OnTAD.git &&\
    cd OnTAD &&\
    git checkout 3da5d9a4569b1f316d4508e60781f22f338f68b1
RUN              cd /opt/OnTAD/src && make clean && make
ENV PATH="/opt/OnTAD/src:${PATH}"

# Install cooltools environment
RUN conda env create -f /temp/install/cooltools.yml 

WORKDIR /home

# Install bioframe, cooltools and pairlib as well as our own NGS library
RUN source activate cooltools &&\
    pip install git+git://github.com/mirnylab/bioframe@40ca346f8726cf809a16fca4df21298f7c096dc3 &&\
    pip install git+git://github.com/mirnylab/cooltools@26b885356e5fd81dd6f34ef688edc45a020ca9d0 &&\
    pip install git+git://github.com/mirnylab/pairlib@663eeb52405677dfd3117e79a1b31b7308b4bd70 &&\
    pip install git+git://github.com/gerlichlab/NGS.git &&\
    conda list > conda_packages_version_list.txt

CMD /bin/bash