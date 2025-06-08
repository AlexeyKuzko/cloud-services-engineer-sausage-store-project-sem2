# Sausage Store

```bash
sausage-store
├── .github/workflows # Файлы для сборки и деплоя с помощью GitHub Actions
│   └── main.yaml # Github-workflow файл для GitHub Actions
├── LICENSE
├── README.md
├── backend # Код приложения Backend
├── backend-report # Код приложения Backend-report
├── frontend # Код приложения Frontend
└── sausage-store-chart # Чарты для деплоя
    ├── Chart.yaml
    ├── charts
    │   ├── backend # Чарт приложения Backend
    │   │   ├── Chart.yaml
    │   │   └── templates
    │   ├── frontend # Чарт приложения Frontend
    │   │   └── templates
    │   └── infra # Чарт инфраструктурных приложений
    │       ├── Chart.yaml
    │       └── templates
    └── values.yaml
```

![image](https://user-images.githubusercontent.com/9394918/121517767-69db8a80-c9f8-11eb-835a-e98ca07fd995.png)


## Technologies used

* Frontend – TypeScript, Angular.
* Backend  – Java 16, Spring Boot, Spring Data.
* Database – H2.

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
