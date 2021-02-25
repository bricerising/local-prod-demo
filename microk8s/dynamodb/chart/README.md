# Dropwizard
This is a generic chart for deploying dropwizard applications.

```bash
helm repo add pago s3://pago-charts
helm repo update

helm upgrade --install APP_NAME pago/dropwizard
```

# Values
```
deployment.pod.annotations:
    - Map - Used to set annotations on created pods
    - default - { kuma.io/direct-access-services: '*' }
deployment.image:
    - String - Used to set docker image used for deployment
    - default - ''
deployment.version:
    - String - Used to set version, or tag, of docker image used for deployment
    - default - ''
deployment.env:
    - Map - Used to set environment variables in deployed pods
    - default - {}
deployment.port:
    - Int - Used to set application port for deployment
    - default - 8080
deployment.resources:
    - Map - Used to set resource allocations for deployed app
    - default - 
        limits:
          memory: 256M
          cpu: .3
service.type:
    - String - Used to set kubernetes service type, this should probably never be changed
    - default - ClusterIP
ingress.domain:
    - String - High level domain of deployed applcation
    - default - pagoservices.com
ingress.application:
    - String - Name or identifier of application. Used when creating dns records
    - default - ''
```