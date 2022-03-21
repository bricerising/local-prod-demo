FROM maven:3.8.4-jdk-11 as builder

COPY . /project
WORKDIR /project

RUN mvn clean install

FROM openjdk:11

RUN useradd -ms /bin/bash quotes
WORKDIR /home/quotes

ENV LIFECYCLE='dev'

# Copy jar and config files from builder stage
COPY --from=builder /project/quotes-service/target/quotes-service.jar quotes-service.jar
COPY --from=builder /project/quotes-service/configs configs

RUN chown -R quotes /home/quotes
USER quotes

CMD exec java -jar quotes-service.jar server configs/${LIFECYCLE}.yml
