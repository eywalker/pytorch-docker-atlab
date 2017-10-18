FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
LABEL maintainer="Edgar Y. Walker <edgar.walker@gmail.com>"

# Install essential Ubuntu packages
# and upgrade pip
RUN apt-get update &&\
    apt-get install -y software-properties-common \
                       build-essential \
                       git \
                       wget \
                       vim \
                       curl \
                       zip \
                       zlib1g-dev \
                       unzip \
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python-dev \
                       python3-dev \
                       python3-pip \
                       python3-tk \
                       python3-wheel \
                       graphviz \
                       libhdf5-dev \
                       swig &&\
    ln -s /usr/bin/python3 /usr/local/bin/python &&\
    ln -s /usr/bin/pip3 /usr/local/bin/pip &&\
    pip install --upgrade pip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /src

# Install essential Python packages
RUN pip3 --no-cache-dir install \
         numpy \
         matplotlib \
         scipy \
         pandas \
         jupyter \
         scikit-learn \
         seaborn \
         graphviz \
         gpustat \
         h5py \
         http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp35-cp35m-manylinux1_x86_64.whl \
         torchvision \
         datajoint 

# Add profiling library support
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}
