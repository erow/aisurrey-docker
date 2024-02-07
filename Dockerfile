
ARG PYTORCH="2.1.1"
ARG CUDA="12.1"
ARG CUDNN="8"


# FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime
FROM docker.io/pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-runtime



# To fix GPG key error when running apt-get update
# RUN rm /etc/apt/sources.list.d/cuda.list \
#     && rm /etc/apt/sources.list.d/nvidia-ml.list \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# Install system dependencies for opencv-python

RUN  apt update &&  apt install -y libgl1 libglib2.0-0 \
    && apt clean 
    # && rm -rf /var/lib/apt/lists/*

RUN pip install mmcv==2.1.0 -f https://download.openmmlab.com/mmcv/dist/cu121/torch2.1/index.html \
    && pip cache purge
# Verify the installation
RUN python -c 'import mmcv;print(mmcv.__version__)'

# Install FFCV
RUN conda install cupy pkg-config libjpeg-turbo opencv cudatoolkit=${CUDA} numba -c pytorch -c conda-forge
RUN pip install ffcv \
    && pip cache purge

# useful tools
RUN pip install timm wandb imageio pandas gin-config tqdm\
    && pip cache purge
