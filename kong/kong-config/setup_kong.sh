#!/bin/bash

# RUN 
# chmod +x setup_kong.sh
# ./setup_kong.sh

# Plugin JWT
k apply -f kong/plugins/jwt-auth.yaml
k apply -f kong/plugins/cors.yaml
k apply -f kong/service-monitor.yaml

# Port Foward Kong Admin
k port-forward service/kong-kong-admin 2343:8001 -n kong

# Consumidor e Credenciais JWT
curl -i -X POST http://localhost:2343/consumers/ --data "username=kong"
curl -i -X POST http://localhost:2343/consumers/kong/jwt --data "key=kong-jwt" --data "secret=kong-jwt-secret-5dMIdKChUaejehAekD48tvJMdsIgP6Lgm0pfsE"

# Serviços e Rotas
k apply -f kong/services/services-routes.yaml

# Port Foward Konga
k port-forward service/konga-service 8090:80 -n kong

# Connec to Konga to Kong Admin
http://kong-kong-admin.kong.svc.cluster.local:8001

# Plugins JWT
curl -i -X POST http://localhost:2343/services/loki-service/plugins --data "name=jwt" --data "config.header_names=KONG_AUTH" --data "config.run_on_preflight=true"
curl -i -X POST http://localhost:2343/services/tempo-service/plugins --data "name=jwt" --data "config.header_names=KONG_AUTH" --data "config.run_on_preflight=true"
curl -i -X POST http://localhost:2343/services/mimir-service/plugins --data "name=jwt" --data "config.header_names=KONG_AUTH" --data "config.run_on_preflight=true"