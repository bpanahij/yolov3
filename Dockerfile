# YOLOv3 🚀 by Ultralytics, GPL-3.0 license

# Start FROM Nvidia PyTorch image https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-devel
#FROM nvcr.io/nvidia/pytorch:21.11-py3
#FROM dzw001/cuda11.1-cudnn8-python3.6-pytorch1.8.1-ubuntu18.04

# Install linux packages
RUN apt clean
RUN apt update && apt install -y zip htop screen libgl1-mesa-glx libglib2.0-0 vim 
# Install python dependencies
COPY requirements.txt .
RUN python -m pip install --upgrade pip
#RUN pip uninstall -y nvidia-tensorboard nvidia-tensorboard-plugin-dlprof
RUN pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook wandb>=0.12.2
RUN conda install numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests
#RUN conda install -c pytorch magma-cuda110

#WORKDIR /usr/src
#RUN git clone --recursive https://github.com/pytorch/pytorch
#WORKDIR /usr/src/pytorch
#RUN git submodule sync
#RUN git submodule update --init --recursive
#RUN export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}
#RUN python setup.py install

RUN conda install torchvision
RUN conda install numpy Pillow 

#WORKDIR /usr/src
# RUN pip install --no-cache torch==1.10.0+cu113 torchvision==0.11.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
COPY . /usr/src/app

# Downloads to user config dir
ADD https://ultralytics.com/assets/Arial.ttf /root/.config/Ultralytics/

# Set environment variables
# ENV HOME=/usr/src/app


# Usage Examples -------------------------------------------------------------------------------------------------------

# Build and Push
# t=ultralytics/yolov3:latest && sudo docker build -t $t . && sudo docker push $t

# Pull and Run
# t=ultralytics/yolov3:latest && sudo docker pull $t && sudo docker run -it --ipc=host --gpus all $t

# Pull and Run with local directory access
# t=ultralytics/yolov3:latest && sudo docker pull $t && sudo docker run -it --ipc=host --gpus all -v "$(pwd)"/datasets:/usr/src/datasets $t

# Kill all
# sudo docker kill $(sudo docker ps -q)

# Kill all image-based
# sudo docker kill $(sudo docker ps -qa --filter ancestor=ultralytics/yolov3:latest)

# Bash into running container
# sudo docker exec -it 5a9b5863d93d bash

# Bash into stopped container
# id=$(sudo docker ps -qa) && sudo docker start $id && sudo docker exec -it $id bash

# Clean up
# docker system prune -a --volumes

# Update Ubuntu drivers
# https://www.maketecheasier.com/install-nvidia-drivers-ubuntu/

# DDP test
# python -m torch.distributed.run --nproc_per_node 2 --master_port 1 train.py --epochs 3
CMD ["bash"]
