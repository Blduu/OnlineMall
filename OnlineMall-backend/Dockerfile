FROM maven:3.9.9-amazoncorretto-8 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /app/src/
RUN mvn clean package -DskipTests

FROM openjdk:8-jre-slim

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# 创建文件上传目录
RUN mkdir -p /app/avatar /app/file
COPY avatar/ /app/avatar/
COPY file/ /app/file/

# 设置环境变量，指定使用docker环境配置
ENV SPRING_PROFILES_ACTIVE=docker

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"] 