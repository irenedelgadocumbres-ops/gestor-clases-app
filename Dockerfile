# 1. ETAPA DE CONSTRUCCIÓN (Usamos Maven para crear el .war)
FROM maven:3.9.6-eclipse-temurin-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# 2. ETAPA DE EJECUCIÓN (Usamos Tomcat 10 para Jakarta EE)
FROM tomcat:10.1-jdk17
# Borramos la app por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copiamos nuestra app compilada y la renombramos a ROOT.war para que salga en la página principal
COPY --from=build target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
