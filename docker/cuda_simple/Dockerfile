ARG CUDA_BUILDER_IMAGE="12.1.1-devel-ubuntu22.04"
ARG CUDA_RUNTIME_IMAGE="12.1.1-runtime-ubuntu22.04"
ARG VIRTUAL_ENV_DIR=/opt/env

FROM nvidia/cuda:${CUDA_BUILDER_IMAGE} AS builder

ARG VIRTUAL_ENV_DIR

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y git build-essential \
    python3 python3-pip python3-venv gcc wget \
    ocl-icd-opencl-dev opencl-headers clinfo \
    libclblast-dev libopenblas-dev \
    && mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# setting build related env vars
ENV CUDA_DOCKER_ARCH=all
ENV LLAMA_CUBLAS=1

RUN python3 -m venv ${VIRTUAL_ENV_DIR}
ENV PATH=${VIRTUAL_ENV_DIR}/bin:$PATH

# Install llama-cpp-python (build with cuda)
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python[server]


FROM nvidia/cuda:${CUDA_RUNTIME_IMAGE}

ARG VIRTUAL_ENV_DIR

COPY --from=builder ${VIRTUAL_ENV_DIR} ${VIRTUAL_ENV_DIR}

# We need to set the host to 0.0.0.0 to allow outside access
ENV HOST 0.0.0.0

ENV PATH=${VIRTUAL_ENV_DIR}/bin:$PATH

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y python3 \
    && apt-get clean

RUN groupadd -r user && useradd -r -g user user

USER user

# Run the server
ENTRYPOINT ["python", "-m", "llama_cpp.server"]
