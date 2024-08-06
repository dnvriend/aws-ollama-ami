# aws-ollama-ami

A project to build aws-ollama-ami Amazon AMI using Hashicorp [packer](https://www.packer.io/). Used to find out how fast open source
LLM models will run on AWS on 4x L4 GPUs. 

The TL;DR is that:
- On 4xL4 GPUs all models up to 12b will run very fast, above the speed is lacking
- On 8xL4 GPUs 

## Environment vars

- PKR_VAR_vpc_id=<vpc-id>
- PKR_VAR_subnet_id=<subnet_id>

## Commands

```shell
# change to root
$ sudo su -

# status of ollama
$ systemctl status ollama

# status of nvidia-smi
$ nvidia-smi
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.183.01             Driver Version: 535.183.01   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA L4                      On  | 00000000:38:00.0 Off |                    0 |
| N/A   49C    P0              29W /  72W |      0MiB / 23034MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA L4                      On  | 00000000:3A:00.0 Off |                    0 |
| N/A   46C    P0              28W /  72W |      0MiB / 23034MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   2  NVIDIA L4                      On  | 00000000:3C:00.0 Off |                    0 |
| N/A   45C    P0              27W /  72W |      0MiB / 23034MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   3  NVIDIA L4                      On  | 00000000:3E:00.0 Off |                    0 |
| N/A   46C    P0              28W /  72W |      0MiB / 23034MiB |      3%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|  No running processes found                                                           |
+---------------------------------------------------------------------------------------+

# version of ollama
$ ollama -v
ollama version is 0.3.3

# run llama 3.1 8b uses 6360MiB / 23028MiB memory
ollama run llama3.1, very fast, absolutely usable.

# run ollama 3.1 70b only runs on 4GPUs
# 40GB download, not as fast as the 8b models, but fast enough for validation use cases 
ollama run llama3.1:70b
$ nvidia-smi
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.183.01             Driver Version: 535.183.01   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA L4                      On  | 00000000:38:00.0 Off |                    0 |
| N/A   59C    P0              43W /  72W |  20689MiB / 23034MiB |     36%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA L4                      On  | 00000000:3A:00.0 Off |                    0 |
| N/A   48C    P0              39W /  72W |  12080MiB / 23034MiB |     22%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   2  NVIDIA L4                      On  | 00000000:3C:00.0 Off |                    0 |
| N/A   46C    P0              42W /  72W |  11588MiB / 23034MiB |     20%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   3  NVIDIA L4                      On  | 00000000:3E:00.0 Off |                    0 |
| N/A   47C    P0              42W /  72W |  11588MiB / 23034MiB |     20%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A     15761      C   ...unners/cuda_v11/ollama_llama_server     8764MiB |
|    0   N/A  N/A     16881      C   ...unners/cuda_v11/ollama_llama_server    11912MiB |
|    1   N/A  N/A     16881      C   ...unners/cuda_v11/ollama_llama_server    12072MiB |
|    2   N/A  N/A     16881      C   ...unners/cuda_v11/ollama_llama_server    11580MiB |
|    3   N/A  N/A     16881      C   ...unners/cuda_v11/ollama_llama_server    11580MiB |
+---------------------------------------------------------------------------------------+

# run mistral nemo 12b can run on 1 GPU
# 8GB download, very fast, absolutely usable.
ollama run mistral-nemo

# run mistral large 123b uses 4GPUs L4 fully utilized
# 70GB download, ollama does not run the model fast on this setup; not usable.
ollama run mistral-large
$ nvidia-smi
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.183.01             Driver Version: 535.183.01   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA L4                      On  | 00000000:38:00.0 Off |                    0 |
| N/A   49C    P0              41W /  72W |  20160MiB / 23034MiB |     37%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA L4                      On  | 00000000:3A:00.0 Off |                    0 |
| N/A   48C    P0              40W /  72W |  19386MiB / 23034MiB |     16%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   2  NVIDIA L4                      On  | 00000000:3C:00.0 Off |                    0 |
| N/A   47C    P0              43W /  72W |  19386MiB / 23034MiB |     13%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   3  NVIDIA L4                      On  | 00000000:3E:00.0 Off |                    0 |
| N/A   49C    P0              42W /  72W |  18926MiB / 23034MiB |     34%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A     13852      C   ...unners/cuda_v11/ollama_llama_server    20152MiB |
|    1   N/A  N/A     13852      C   ...unners/cuda_v11/ollama_llama_server    19378MiB |
|    2   N/A  N/A     13852      C   ...unners/cuda_v11/ollama_llama_server    19378MiB |
|    3   N/A  N/A     13852      C   ...unners/cuda_v11/ollama_llama_server    18918MiB |
+---------------------------------------------------------------------------------------+

# run qwen:72b on 4GPUs
# 40GB download
ollama run qwen2:72b
$ nvidia-smi


```

## Remote access

```shell
# run models, replace localhost:11434 with remote IP of server
 
curl http://localhost:11434/api/pull -d '{"model": "mistral-nemo", "keep_alive": -1}'
curl http://localhost:11434/api/generate -d '{"model": "mistral-nemo", "keep_alive": -1}'
curl http://localhost:11434/api/generate -d '{"model": "mistral-nemo", "keep_alive": -1}'
```

## Resize disk

```shell
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1       259:0    0   500G  0 disk
├─nvme0n1p1   259:5    0    80G  0 part /
└─nvme0n1p128 259:6    0     1M  0 part
nvme1n1       259:1    0 875.5G  0 disk
nvme2n1       259:2    0 875.5G  0 disk
nvme3n1       259:3    0 875.5G  0 disk
nvme4n1       259:4    0 875.5G  0 disk

$ growpart /dev/nvme0n1 1
CHANGED: partition=1 start=4096 old: size=167768031 end=167772127 new: size=1048571871 end=1048575967

$ df -T / | grep nvme0n1p1
/dev/nvme0n1p1 xfs   83873772 82055820   1817952  98% /

$ xfs_growfs /
meta-data=/dev/nvme0n1p1         isize=512    agcount=41, agsize=524159 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0
         =                       reflink=0    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=20971003, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 20971003 to 131071483

$ dh -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs         91G     0   91G   0% /dev
tmpfs            91G     0   91G   0% /dev/shm
tmpfs            91G  972K   91G   1% /run
tmpfs            91G     0   91G   0% /sys/fs/cgroup
/dev/nvme0n1p1  500G   79G  422G  16% /
tmpfs            19G     0   19G   0% /run/user/0
tmpfs            19G     0   19G   0% /run/user/1000
```
 
# Resources

- https://ollama.com/blog
- https://ollama.com/library
- https://www.packer.io/

