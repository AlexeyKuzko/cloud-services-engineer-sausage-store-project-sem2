# Infrastructure as Code

Этот каталог содержит Terraform конфигурацию для развертывания инфраструктуры в Яндекс.Облаке.

## Структура

```
infra/
├── provider.tf              # Конфигурация провайдера Terraform
├── variables.tf             # Переменные Terraform
├── terraform.tfvars         # Значения переменных
├── vpc.tf                   # VPC сеть и Security Group
├── vm-dev.tf               # Dev виртуальная машина
├── vm-prod.tf              # Prod виртуальная машина
├── outputs.tf              # Выходные значения
├── .checkov.yml            # Конфигурация Checkov
├── custom_policies/        # Custom политики для Checkov
│   └── ensure_yandex_instance_has_labels.yml
└── test/                   # Terratest тесты
    ├── go.mod
    ├── vm_avalability_test.go
    └── vm_prod_sg_check_test.go
```

## Переменные

Необходимо настроить следующие переменные в GitLab CI/CD:

- `YC_TOKEN` - OAuth токен Яндекс.Облака
- `CLOUD_ID` - ID облака
- `FOLDER_ID` - ID каталога
- `TF_HTTP_PASSWORD` - Access Token для работы с Terraform state

## Использование

Инфраструктура развертывается через GitLab CI/CD pipeline. Доступны следующие операции:

- `terraform` - развертывание инфраструктуры (plan, apply, destroy)
- `ansible` - конфигурация серверов (будущая функциональность)
- `k8s` - развертывание в Kubernetes (будущая функциональность)

## Тестирование

Проект включает два типа тестов:

1. **Checkov** - статический анализ безопасности Terraform кода
2. **Terratest** - интеграционные тесты инфраструктуры

### Checkov

Проверяет соответствие кода лучшим практикам безопасности. Включает custom политику для проверки наличия labels у виртуальных машин.

### Terratest

- `vm_avalability_test.go` - проверяет доступность виртуальных машин
- `vm_prod_sg_check_test.go` - проверяет корректность настройки Security Group для prod VM
