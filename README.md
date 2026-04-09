# Terraform Provisioning

## Overview

VPC, ECS, EC2, ALB 등 AWS 인프라를 Terraform 모듈 구조로 설계하고, 환경(dev/stg/prod)별 설정을 분리하여 배포 및 관리합니다.

## Project Structure

```
├── env/                       # 환경별 설정
│   └── stg/                   # 스테이징 환경
│       └── apne2/             # ap-northeast-2 리전
│           └── sandbox/       # sandbox 인프라 스택
├── modules/                   # 재사용 가능한 Terraform 모듈
│   └── aws/
│       ├── acm/               # AWS Certificate Manager
│       ├── cicd/              # CI/CD 리소스 (CodeDeploy)
│       ├── compute/           # Compute resources (EC2, ECS, EKS)
│       ├── ecr/               # Elastic Container Registry
│       ├── elb/               # Elastic Load Balancer
│       ├── iam/               # IAM roles and policies
│       ├── network/           # VPC and networking
│       ├── storage/           # S3 storage
│       └── vpc_endpoint/      # VPC endpoints
└── atlantis.yaml              # Atlantis configuration for GitOps
```

## Prerequisites

- Terraform v1.11.4
- AWS CLI 2.33.29
- Atlantis (optional: for GitOps workflow)

## Deployment

```bash
# 환경 디렉토리로 이동
cd env/stg/apne2/sandbox/network

terraform init
terraform plan
terraform apply
```