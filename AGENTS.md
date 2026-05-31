# 프로젝트: sandbox-tf-provisioning

## 기술 스택

- Terraform 1.11.4
- AWS Provider (ap-northeast-2) — `env/stg/apne2/commerce/_common/provider.tf` 공통 설정, 각 스택에 복사
- Atlantis — GitOps PR 기반 plan/apply 워크플로
- tf-summarize — `make plan` 시 plan 결과 트리 형식 출력에 사용
- terraform-docs — 모듈 문서 자동화
- GNU Make — 스택별 init/plan/apply/destroy 래퍼

## 스택 구조

`env/stg/apne2/commerce/` 아래 각 디렉토리가 독립된 Terraform 루트(state 파일 분리)다.

| 스택        | remote_state 참조    | outputs.tf |
| ----------- | -------------------- | ---------- |
| global      | 없음                 | ✓          |
| network     | 없음                 | ✓          |
| ecr         | 없음                 | 없음       |
| elb         | network              | ✓          |
| compute/ec2 | global, network      | 없음       |
| compute/ecs | global, network, elb | 없음       |
| cicd        | global, elb          | 없음       |
| storage     | 없음                 | 없음       |

배포 순서: global → network → ecr → elb → compute(ec2/ecs 순서 무관) → cicd / storage(순서 무관)

## 모듈 구조

`modules/aws/` 하위 모듈 목록과 실제 파일 현황:

| 모듈            | 파일 현황                              |
| --------------- | -------------------------------------- |
| acm             | variables, main, outputs, locals       |
| route53         | variables, main, outputs, data         |
| cicd/codedeploy | variables, main (**outputs.tf 없음**)  |
| compute/ec2     | variables, main, outputs, locals, data |
| compute/ecs     | variables, main, outputs, locals       |
| compute/eks     | variables, main, outputs               |
| ecr             | variables, main (**outputs.tf 없음**)  |
| elb             | variables, main, outputs, locals       |
| iam             | variables, main, outputs, data         |
| network         | variables, main, outputs, locals       |
| s3              | variables, main, outputs, locals       |

## 아키텍처 규칙

- CRITICAL: 모든 AWS 리소스는 `modules/aws/` 하위 모듈을 통해 생성한다. `env/` 루트 스택에서 `resource` 블록을 직접 선언하지 않는다.
- CRITICAL: 모든 리소스에 `tags = merge(var.tags, { Name = "..." })` 패턴으로 태그를 붙인다.
- 신규 모듈 추가 시 `variables.tf` / `main.tf` / `outputs.tf` / `locals.tf` 기본 구조를 따른다. data source가 필요하면 `data.tf`를 추가한다.
- 여러 리소스를 생성할 때는 `for_each`를 기본으로 사용한다. AZ 인덱싱처럼 순서가 고정된 경우에만 `count`를 허용한다 (network 모듈의 subnet이 예시).
- 스택 간 참조는 `remote_state.tf`에 `data "terraform_remote_state"` 블록만 선언한다. `main.tf`에 섞지 않는다.
- `terraform fmt -check` 통과가 Atlantis plan의 선제 조건이다. 모든 `.tf` 파일은 포맷을 맞춘다.

## Atlantis 설정

`atlantis.yaml`의 현재 상태:

1. **8개 project 항목**: global, network, ecr, elb, compute/ec2, compute/ecs, cicd, storage 각각 독립된 루트로 등록.
2. **workflow**: `commerce-workflow-stg` — `fmt -check → init → plan -lock=true` 순서.
3. **when_modified**: 각 스택이 참조하는 모듈 경로를 상대 경로로 지정. `compute/` 하위는 dir 깊이가 1단계 더 깊으므로 `../../../../../../` 사용.

## 개발 프로세스

- CRITICAL: 변경 사항은 PR로 제출하고 Atlantis가 plan을 실행한다. 로컬에서 직접 apply 금지.
- PR merge 전 plan 결과 리뷰 필수. `apply_requirements: [mergeable, approved]`
- 커밋 메시지는 conventional commits 형식을 따를 것 (feat:, fix:, docs:, refactor:)

## 명령어

```bash
# 각 스택 디렉토리(예: env/stg/apne2/commerce/global/)에서 실행
make init   # terraform init
make plan   # terraform plan + tf-summarize 트리 출력

terraform fmt -check -diff   # 포맷 검증 (Atlantis가 자동 실행)
terraform-docs markdown .    # 모듈 문서 생성
```
