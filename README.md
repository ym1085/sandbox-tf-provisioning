# Terraform Provisioning

## Overview

AWS 인프라를 Terraform으로 관리하는 IaC 리포지토리입니다. 모듈화된 구조를 기반으로 dev/stg/prod 환경별 인프라를 일관되게 프로비저닝하고 관리합니다.

## Project Structure

```text
├── env/
│   └── stg/
│       └── apne2/
│           └── commerce/
│               ├── _common/        # 공통 Provider 설정
│               ├── global/         # IAM, ACM, Route53 등 글로벌 리소스
│               ├── network/        # VPC, Subnet, Route Tables
│               ├── ecr/            # ECR Container Registry
│               ├── elb/            # Load Balancer, Target Group
│               ├── compute/
│               │   ├── ec2/        # EC2 인스턴스
│               │   └── ecs/        # ECS 클러스터 및 Fargate/EC2 워크로드
│               ├── cicd/           # CodeDeploy 등 CI/CD 파이프라인 리소스
│               └── storage/        # S3 버킷
│
├── modules/
│   └── aws/
│       ├── acm/                    # ACM 인증서
│       ├── route53/                # Route53 DNS
│       ├── cicd/                   # CI/CD (CodeDeploy)
│       ├── compute/                # EC2, ECS, EKS
│       ├── ecr/                    # ECR Container Registry
│       ├── elb/                    # Load Balancer, Target Group
│       ├── iam/                    # IAM Roles/Policies
│       ├── network/                # VPC, Subnets, Route Tables
│       └── s3/                     # S3 Buckets
├── docs/ATLANTIS.md               # Atlantis 설정 가이드
├── atlantis.yaml                  # Atlantis 실행 설정
└── .terraform-docs.yml            # Terraform Docs 설정
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
Atlantis 설정 설명은 [`docs/ATLANTIS.md`](./docs/ATLANTIS.md)에서 관리합니다.

### 1. Root (Environment) Stacks (`env/stg/apne2/commerce/`)

> 실제 인프라 **배포 단위**이며, **global → network → ecr → elb → compute → cicd** 순서로 각 폴더의 Makefile을 통해 실행합니다.

| 스택 이름         | 경로                                 | 주요 설명                                                          |
| ----------------- | ------------------------------------ | ------------------------------------------------------------------ |
| **global**        | `env/stg/apne2/commerce/global`      | IAM, ACM, Route53 등 리전/계정 수준의 글로벌 및 공통 리소스        |
| **network**       | `env/stg/apne2/commerce/network`     | VPC, Subnet, Route Table 등 기본 네트워크 인프라                   |
| **ecr**           | `env/stg/apne2/commerce/ecr`         | 이미지 보관용 ECR Container Registry                               |
| **elb**           | `env/stg/apne2/commerce/elb`         | Application/Network Load Balancer 및 Target Group                  |
| **compute (EC2)** | `env/stg/apne2/commerce/compute/ec2` | EC2 인스턴스 기반 컴퓨팅 리소스                                    |
| **compute (ECS)** | `env/stg/apne2/commerce/compute/ecs` | ECS 클러스터 및 Fargate/EC2 워크로드                               |
| **cicd**          | `env/stg/apne2/commerce/cicd`        | CodeDeploy를 포함한 CI/CD 배포 파이프라인 구성 리소스              |
| **storage**       | `env/stg/apne2/commerce/storage`     | S3 버킷 생성 및 정책/라이프사이클 규칙 관리                        |
| **\_common**      | `env/stg/apne2/commerce/_common`     | 환경 내 스택들이 공통으로 참조하는 Provider 및 Backend 설정 가이드 |

### 2. Terraform Modules (`modules/aws/`)

> 일관된 인프라 구성을 위한 재사용 가능한 모듈 목록입니다.

| 모듈 이름      | 경로                          | 주요 설명                                                        |
| -------------- | ----------------------------- | ---------------------------------------------------------------- |
| **ACM**        | `modules/aws/acm`             | ACM 인증서 발급 및 DNS 검증 레코드 관리                          |
| **Route53**    | `modules/aws/route53`         | Route53 호스팅 영역 생성 및 관리                                 |
| **CodeDeploy** | `modules/aws/cicd/codedeploy` | CI/CD용 AWS CodeDeploy 애플리케이션 및 배포 그룹 구성            |
| **EC2**        | `modules/aws/compute/ec2`     | EC2 인스턴스 생성 (보안 그룹 및 IAM Role 포함)                   |
| **ECS**        | `modules/aws/compute/ecs`     | ECS 클러스터, Task Definition 및 Service 구성 템플릿             |
| **ECR**        | `modules/aws/ecr`             | ECR 프로비저닝                                                   |
| **ELB**        | `modules/aws/elb`             | Load Balancer, Listener 및 Target Group 구성                     |
| **IAM**        | `modules/aws/iam`             | 재사용 가능한 IAM Role 및 Policy 구성                            |
| **Network**    | `modules/aws/network`         | VPC, Subnet, Route Table, IGW/NAT 등 핵심 네트워크 토폴로지 구성 |
| **S3**         | `modules/aws/s3`              | S3 버킷 생성 및 정책/라이프사이클 규칙 관리                      |

## Deployment

각 스택은 `remote_state` 의존성이 존재하므로, 기본 인프라인 `global`, `network`, `ecr` 스택을 먼저 배포한 후, 이를 참조하는 `elb`, `compute`, `cicd` 스택을 순차적으로 배포해야 합니다.
또한, 각 디렉터리 내에 포함된 `Makefile`을 사용하여 프로비저닝을 수행합니다.

### 배포 순서 및 방법 예시

```bash
# Terraform 배포 대상 스택 디렉터리로 이동 (예: Network)
cd env/stg/apne2/commerce/network

# Terraform 초기화 및 플랜 확인
make init
make plan
```

