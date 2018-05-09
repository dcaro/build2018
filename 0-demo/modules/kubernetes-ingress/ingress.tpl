apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${app_name}-front
  annotations:
    kubernetes.io/ingress.class: addon-http-application-routing
spec:
  rules:
  - host: ${app_name}.${CLUSTER_SPECIFIC_DNS_ZONE}
    http:
      paths:
      - backend:
          serviceName: ${app_name}-front
          servicePort: 80
        path: /