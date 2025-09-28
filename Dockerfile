# Stage 1 - package the custom theme into a JAR
FROM eclipse-temurin:21-jdk AS theme-builder
WORKDIR /workspace
COPY theme ./theme
RUN mkdir META-INF \
    && echo '{ "themes": [ { "name": "green-sky-login", "types": [ "login" ] } ] }' > META-INF/keycloak-themes.json
RUN mkdir -p /workspace/output \
    && jar cf /workspace/output/green-sky-login.jar .

# Stage 2 - assemble the final Keycloak image with the theme provider
FROM quay.io/keycloak/keycloak:26.3.5
USER root
COPY --from=theme-builder /workspace/output/green-sky-login.jar /opt/keycloak/providers/green-sky-login.jar
RUN /opt/keycloak/bin/kc.sh build

USER keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
