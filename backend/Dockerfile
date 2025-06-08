#Это так называемый мультистейдж docker-файл. Сначала делаем образ, который соберёт нам java-приложение,
#а затем из него берём собранный артефакт и кладём его в новый образ, чтобы оставить в нём меньше лишнего

# build
FROM maven:3.9-amazoncorretto-17 AS builder
# задаём переменную VERSION, которая будет использоваться для сборки проекта
ARG VERSION=1.0.0
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./

RUN mvn package -Dversion.application=${VERSION}

# release
FROM amazoncorretto:17-alpine
ARG VERSION=1.0.0
WORKDIR /app
# создаём пользователя jaruser
RUN addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && apk add --no-cache dumb-init \
    && apk add --update curl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /logs/reports \
    && chown -R jaruser:jaruser /logs
COPY --chown=jaruser:jaruser \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
EXPOSE 8080
# приложение будет запускаться под пользователем jaruser
USER jaruser
ENTRYPOINT ["dumb-init", "java", "-jar", "-Dmyserver.bindPort=8080", "./sausage-store.jar"]