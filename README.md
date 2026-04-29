# Terraform Provisioning

## Overview

AWS 인프라를 Terraform으로 관리하는 IaC 리포지토리입니다. 모듈화된 구조를 기반으로 dev/stg/prod 환경별 인프라를 일관되게 프로비저닝하고 관리합니다.

## Project Structure

```text
├── env/
│   └── stg/
│       └── apne2/
│           └── sandbox/
│               ├── _common/        # 공통 Provider 설정
│               ├── 01-global/      # S3, ACM/Route53, IAM 등 글로벌 리소스
│               ├── 02-network/     # VPC, Subnet, Route Tables
│               ├── 03-ecr/         # ECR Container Registry
│               ├── 04-elb/         # Load Balancer, Target Group
│               ├── 05-compute/
│               │   ├── ec2/        # EC2 인스턴스
│               │   └── ecs/        # ECS 클러스터 및 Fargate/EC2 워크로드
│               └── 06-cicd/        # CodeDeploy 등 CI/CD 파이프라인 리소스
│
├── modules/
│   └── aws/
│       ├── acm_route53/            # ACM & Route53
│       ├── cicd/                   # CI/CD (CodeDeploy)
│       ├── compute/                # EC2, ECS, EKS
│       ├── ecr/                    # ECR Container Registry
│       ├── elb/                    # Load Balancer, Target Group
│       ├── iam/                    # IAM Roles/Policies
│       ├── network/                # VPC, Subnets, Route Tables
│       └── s3/                     # S3 Buckets
└── atlantis.yaml                   # Atlantis 설정
└── .terraform-docs.yml             # Terraform Docs 설정
```

## Prerequisites

- Terraform v1.11.4
- AWS CLI 2.33.29
- GNU Make
- terraform-docs
- tf-summarize
- Atlantis (optional)

## Documentation

실제 프로비저닝을 수행하는 **Root (Environment) Stacks**와 재사용성을 위한 **Terraform Modules**로 구분되어 있습니다. 인프라 구성 및 상세 정보는 아래 표를 참고하시면 됩니다.

### 1. Root (Environment) Stacks (`env/stg/apne2/sandbox/`)

> 실제 인프라 **배포 단위**이며, **01 → 06** 순서로 각 폴더의 Makefile을 통해 실행합니다.

| 스택 이름            | 경로 (README 링크)                                                           | 주요 설명                                                          |
| -------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| **01-global**        | [`env/.../01-global`](./env/stg/apne2/sandbox/01-global/README.md)           | S3, ACM/Route53, IAM 등 리전/계정 수준의 글로벌 및 공통 리소스     |
| **02-network**       | [`env/.../02-network`](./env/stg/apne2/sandbox/02-network/README.md)         | VPC, Subnet, Route Table 등 기본 네트워크 인프라                   |
| **03-ecr**           | [`env/.../03-ecr`](./env/stg/apne2/sandbox/03-ecr/README.md)                 | 이미지 보관용 ECR Container Registry                               |
| **04-elb**           | [`env/.../04-elb`](./env/stg/apne2/sandbox/04-elb/README.md)                 | Application/Network Load Balancer 및 Target Group                  |
| **05-compute (EC2)** | [`env/.../05-compute/ec2`](./env/stg/apne2/sandbox/05-compute/ec2/README.md) | EC2 인스턴스 기반 컴퓨팅 리소스                                    |
| **05-compute (ECS)** | [`env/.../05-compute/ecs`](./env/stg/apne2/sandbox/05-compute/ecs/README.md) | ECS 클러스터 및 Fargate/EC2 워크로드                               |
| **06-cicd**          | [`env/.../06-cicd`](./env/stg/apne2/sandbox/06-cicd/README.md)               | CodeDeploy를 포함한 CI/CD 배포 파이프라인 구성 리소스              |
| **\_common**         | [`env/.../_common`](./env/stg/apne2/sandbox/_common/README.md)               | 환경 내 스택들이 공통으로 참조하는 Provider 및 Backend 설정 가이드 |

### 2. Terraform Modules (`modules/aws/`)

> 일관된 인프라 구성을 위한 재사용 가능한 모듈 목록입니다.

| 모듈 이름         | 경로 (README 링크)                                                  | 주요 설명                                                        |
| ----------------- | ------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **ACM & Route53** | [`modules/.../acm_route53`](./modules/aws/acm_route53/README.md)    | ACM 인증서 발급 및 Route53 DNS 레코드 관리                       |
| **CodeDeploy**    | [`modules/.../codedeploy`](./modules/aws/cicd/codedeploy/README.md) | CI/CD용 AWS CodeDeploy 애플리케이션 및 배포 그룹 구성            |
| **EC2**           | [`modules/.../compute/ec2`](./modules/aws/compute/ec2/README.md)    | EC2 인스턴스 생성 (보안 그룹 및 IAM Role 포함)                   |
| **ECS**           | [`modules/.../compute/ecs`](./modules/aws/compute/ecs/README.md)    | ECS 클러스터, Task Definition 및 Service 구성 템플릿             |
| **ECR**           | [`modules/.../ecr`](./modules/aws/ecr/README.md)                    | ECR 프로비저닝                                                   |
| **ELB**           | [`modules/.../elb`](./modules/aws/elb/README.md)                    | Load Balancer, Listener 및 Target Group 구성                     |
| **IAM**           | [`modules/.../iam`](./modules/aws/iam/README.md)                    | 재사용 가능한 IAM Role 및 Policy 구성                            |
| **Network**       | [`modules/.../network`](./modules/aws/network/README.md)            | VPC, Subnet, Route Table, IGW/NAT 등 핵심 네트워크 토폴로지 구성 |
| **S3**            | [`modules/.../s3`](./modules/aws/s3/README.md)                      | S3 버킷 생성 및 정책/라이프사이클 규칙 관리                      |

## Deployment

각 스택은 `remote_state` 의존성이 존재하므로, 기본 인프라인 `01`, `02`, `03` 스택을 먼저 배포한 후, 이를 참조하는 `04`, `05`, `06` 스택을 순차적으로 배포해야 합니다.
또한, 각 디렉터리 내에 포함된 `Makefile`을 사용하여 프로비저닝을 수행합니다.

### 배포 순서 및 방법 예시

```bash
# Terraform 배포 대상 스택 디렉터리로 이동 (예: Network)
cd env/stg/apne2/sandbox/02-network

# Terraform 초기화 및 플랜 확인
make init
make plan

# 리소스 생성 적용
make apply
```
