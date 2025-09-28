# Stage 1 - package the custom theme into a JAR
FROM eclipse-temurin:21-jdk AS theme-builder
WORKDIR /workspace
COPY theme ./theme
RUN mkdir -p /workspace/output \
    && jar cf /workspace/output/green-sky-login.jar -C theme .

# Stage 2 - assemble the final Keycloak image with the theme provider
FROM quay.io/keycloak/keycloak:26.3.5
USER root
COPY --from=theme-builder /workspace/output/green-sky-login.jar /opt/keycloak/providers/green-sky-login.jar
RUN /opt/keycloak/bin/kc.sh build

ENV KC_SPI_THEME_DEFAULT=green-sky-login \
    KC_SPI_THEME_WELCOME_THEME=green-sky-login

USER keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
