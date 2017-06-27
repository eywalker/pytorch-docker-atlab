FROM nvidia/cuda:8.0-devel-ubuntu16.04 

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDNN_VERSION 6.0.20 
RUN apt-get update && apt-get install -y --no-install-recommends \
         software-properties-common \
         build-essential \
         cmake \
         git \
         wget \
         curl \
         zip \
         zlib1g-dev \
         unzip \
         pkg-config \
         libblas-dev \
         liblapack-dev \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         libcudnn6=$CUDNN_VERSION-1+cuda8.0 \             
         libcudnn6-dev=$CUDNN_VERSION-1+cuda8.0 && \
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \     
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build && \
     /opt/conda/bin/conda create -y --name pytorch-py36 python=3.6.1 numpy pyyaml scipy ipython mkl&& \
     /opt/conda/bin/conda clean -ya 
ENV PATH /opt/conda/envs/pytorch-py36/bin:$PATH
RUN conda install --name pytorch-py36 -c soumith magma-cuda80
# This must be done before pip so that requirements.txt is available

RUN git clone https://github.com/pytorch/pytorch /opt/pytorch

WORKDIR /opt/pytorch

RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    pip install -v .

RUN conda install --name pytorch-py36 -c soumith torchvision

WORKDIR /workspace
RUN chmod -R a+w /workspace
