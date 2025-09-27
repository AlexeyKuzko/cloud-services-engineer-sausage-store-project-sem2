# Sausage Store

```bash
sausage-store
├── .gitlab-ci.yml # GitLab CI/CD конфигурация
├── LICENSE
├── README.md
├── infra # Описание инфраструктуры и тестов
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   ├── vm-dev.tf
│   ├── vm-prod.tf
│   ├── vpc.tf
│   ├── outputs.tf
│   ├── custom_policies
│   │   └── ensure_yandex_instance_has_labels.yml
│   ├── test
│   │   ├── vm_avalability_test.go
│   │   └── vm_prod_sg_check_test.go
│   └── .checkov.yml
├── backend # Код приложения Backend
├── backend-report # Код приложения Backend-report
├── frontend # Код приложения Frontend
└── sausage-store-chart # Чарты для деплоя
    ├── Chart.yaml
    ├── charts
    │   ├── backend # Чарт приложения Backend
    │   │   ├── Chart.yaml
    │   │   └── templates
    │   ├── frontend # Чарт приложения Frontend
    │   │   └── templates
    │   └── infra # Чарт инфраструктурных приложений
    │       ├── Chart.yaml
    │       └── templates
    └── values.yaml
```

![image](https://user-images.githubusercontent.com/9394918/121517767-69db8a80-c9f8-11eb-835a-e98ca07fd995.png)


## Technologies used

* Frontend – TypeScript, Angular.
* Backend  – Java 16, Spring Boot, Spring Data.
* Database – H2.
* Infrastructure – Terraform, Yandex Cloud.
* CI/CD – GitLab CI, Checkov, Terratest.

## Installation guide
### Backend

Install Java 16 and maven and run:

```bash
cd backend
mvn package
cd target
java -jar sausage-store-0.0.1-SNAPSHOT.jar
```

### Frontend

Install NodeJS and npm on your computer and run:

```bash
cd frontend
npm install
npm run build
npm install -g http-server
sudo http-server ./dist/frontend/ -p 80 --proxy http://localhost:8080
```

Then open your browser and go to [http://localhost](http://localhost)

## Infrastructure

Проект включает инфраструктуру как код (IaC) для развертывания в Яндекс.Облаке:

### Компоненты инфраструктуры

- **VPC Network** - облачная сеть для виртуальных машин
- **Security Group** - группа безопасности с правилами:
  - Разрешен весь исходящий трафик
  - Разрешен входящий трафик на порты 22 (SSH) и 8200 (HTTP)
- **Dev VM** - виртуальная машина для разработки
- **Prod VM** - виртуальная машина для продакшена с применением Security Group

### CI/CD Pipeline

Pipeline включает следующие этапы:

1. **Checkov** - статический анализ безопасности Terraform кода
2. **Plan** - планирование изменений инфраструктуры
3. **Apply** - применение изменений
4. **Terratest** - интеграционные тесты инфраструктуры
5. **Destroy** - удаление инфраструктуры (ручной запуск)

### Настройка переменных

В GitLab CI/CD необходимо настроить следующие переменные:

- `YC_TOKEN` - OAuth токен Яндекс.Облака
- `CLOUD_ID` - ID облака
- `FOLDER_ID` - ID каталога
- `TF_HTTP_PASSWORD` - Access Token для работы с Terraform state

### Тестирование

- **Checkov** - проверка соответствия кода лучшим практикам безопасности
- **Terratest** - проверка доступности виртуальных машин и корректности настройки Security Group
