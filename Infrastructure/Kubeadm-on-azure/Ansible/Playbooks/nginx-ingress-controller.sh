#!/bin/bash
cd /tmp/nginx-ingress-controller
kubectl create ns ingress-nginx
kubectl apply -f nginx-ingress-controller.yaml
#kubectl apply -f validating-webhook.yaml
#kubectl apply -f jobs.yaml 
#kubectl apply -f ingress-service-account.yaml
#kubectl apply -f configmap.yaml
#kubectl apply -f services.yaml
#kubectl apply -f deployment.yaml