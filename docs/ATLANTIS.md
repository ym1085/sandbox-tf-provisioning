# Atlantis Guide

`atlantis.yaml`의 핵심 설정만 빠르게 보기 위한 문서다.

## 파일 목적

| 파일               | 역할                                                              |
| ------------------ | ----------------------------------------------------------------- |
| `atlantis.yaml`    | Atlantis가 실제로 읽는 실행 설정                                  |
| `docs/ATLANTIS.md` | 설정 필드 의미, 프로젝트 분리 기준, workflow 의도를 설명하는 문서 |

## `projects` 필드

스택별 Terraform 루트를 Atlantis project로 1:1 매핑한다.

```yaml
- name: sandbox-stg-global
  branch: /^dev$/
  dir: env/stg/apne2/sandbox/01-global
  terraform_version: "1.11.4"
  autoplan:
    enabled: true
    when_modified:
      - "*.tf"
      - "*.tfvars"
      - ".terraform.lock.hcl"
      - "../../../../../modules/aws/s3/**/*.tf"
  workflow: sandbox-workflow-stg
  plan_requirements: [mergeable]
  apply_requirements: [approved]
```

| 필드                            | 의미                                                       |
| ------------------------------- | ---------------------------------------------------------- |
| `name`                          | Atlantis UI와 로그에서 구분할 프로젝트 이름                |
| `branch`                        | Atlantis가 동작할 대상 브랜치 조건                         |
| `dir`                           | Terraform 명령을 실행할 디렉토리                           |
| `terraform_version`             | 해당 프로젝트에서 사용할 Terraform CLI 버전                |
| `delete_source_branch_on_merge` | PR merge 후 source branch 자동 삭제 여부                   |
| `autoplan.enabled`              | PR 생성 또는 수정 시 자동으로 `plan`을 수행할지 여부       |
| `autoplan.when_modified`        | 어떤 파일 변경이 이 project의 autoplan을 트리거하는지 정의 |
| `workflow`                      | 이 project가 사용할 workflow 이름                          |
| `plan_requirements`             | `plan` 실행 조건                                           |
| `apply_requirements`            | `apply` 실행 조건                                          |

## 프로젝트 분리 기준

| Project 이름              | Terraform 루트(`dir`)                  | 참조 모듈 경로             |
| ------------------------- | -------------------------------------- | -------------------------- |
| `sandbox-stg-global`      | `env/stg/apne2/sandbox/01-global`      | `iam`, `s3`, `acm_route53` |
| `sandbox-stg-network`     | `env/stg/apne2/sandbox/02-network`     | `network`                  |
| `sandbox-stg-ecr`         | `env/stg/apne2/sandbox/03-ecr`         | `ecr`                      |
| `sandbox-stg-elb`         | `env/stg/apne2/sandbox/04-elb`         | `elb`                      |
| `sandbox-stg-compute-ec2` | `env/stg/apne2/sandbox/05-compute/ec2` | `compute/ec2`              |
| `sandbox-stg-compute-ecs` | `env/stg/apne2/sandbox/05-compute/ecs` | `compute/ecs`              |
| `sandbox-stg-cicd`        | `env/stg/apne2/sandbox/06-cicd`        | `cicd/codedeploy`          |

- 각 디렉토리가 독립된 `backend.tf`를 가진다
- state 파일이 스택별로 분리된다
- `remote_state` 의존성 때문에 plan 범위를 스택 단위로 끊는 편이 안전하다

## `autoplan.when_modified` 규칙

| 범주                     | 패턴                                       |
| ------------------------ | ------------------------------------------ |
| 현재 루트 Terraform 파일 | `*.tf`                                     |
| 현재 루트 변수 파일      | `*.tfvars`                                 |
| 현재 루트 lock 파일      | `.terraform.lock.hcl`                      |
| 참조 모듈 Terraform 파일 | `modules/aws/.../**/*.tf`에 대한 상대 경로 |

모듈 상대 경로는 `dir` 기준으로 계산한다.

| Project 이름              | `dir` 기준 모듈 상대 경로 예시                       |
| ------------------------- | ---------------------------------------------------- |
| `sandbox-stg-global`      | `../../../../../modules/aws/s3/**/*.tf`              |
| `sandbox-stg-network`     | `../../../../../modules/aws/network/**/*.tf`         |
| `sandbox-stg-ecr`         | `../../../../../modules/aws/ecr/**/*.tf`             |
| `sandbox-stg-elb`         | `../../../../../modules/aws/elb/**/*.tf`             |
| `sandbox-stg-compute-ec2` | `../../../../../../modules/aws/compute/ec2/**/*.tf`  |
| `sandbox-stg-compute-ecs` | `../../../../../../modules/aws/compute/ecs/**/*.tf`  |
| `sandbox-stg-cicd`        | `../../../../../modules/aws/cicd/codedeploy/**/*.tf` |

## `workflow` 필드

모든 project는 같은 workflow를 사용한다.

```yaml
workflows:
  sandbox-workflow-stg:
    plan:
      steps:
        - run: terraform fmt -check -diff
        - init
        - plan:
            extra_args: ["-lock=true"]
```

| Workflow               | 단계         | 실행 내용                    | 의도                               |
| ---------------------- | ------------ | ---------------------------- | ---------------------------------- |
| `sandbox-workflow-stg` | `plan` 1단계 | `terraform fmt -check -diff` | 포맷 불일치를 plan 전에 차단       |
| `sandbox-workflow-stg` | `plan` 2단계 | `terraform init`             | remote backend 초기화 수행         |
| `sandbox-workflow-stg` | `plan` 3단계 | `terraform plan -lock=true`  | state lock으로 동시 실행 충돌 완화 |

## 운영 규칙

| 설정                 | 현재 값       | 의미                                    |
| -------------------- | ------------- | --------------------------------------- |
| `plan_requirements`  | `[mergeable]` | PR이 merge 가능한 상태일 때만 plan 허용 |
| `apply_requirements` | `[approved]`  | 승인 없는 apply 차단                    |
