# 🚀 Kong Stack

This repository provides a comprehensive solution for setting up **Kong** as an API gateway, along with **Konga** (management UI) and **PostgreSQL** for persistence. It uses **Helmfile** for deployment orchestration in Kubernetes.

## 🧰 Components

- **Kong**: API Gateway
- **Konga**: UI for Kong management
- **PostgreSQL**: Database for Kong state

## 📦 Prerequisites

- Kubernetes Cluster (AKS, GKE, etc.)
- Helm 3.x or later
- kubectl installed
- Helmfile installed

## 🚀 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/leozw/kong-stack.git
cd kong-stack
```

### Step 2: Initial Configuration

Navigate to the `kong/kong-config` folder to set up Kong with the necessary plugins, services, and routes.

```bash
cd kong/kong-config
```

### Step 3: Apply Kong Plugins and Configurations

```bash
# Apply JWT and CORS plugins
kubectl apply -f kong/plugins/jwt-auth.yaml
kubectl apply -f kong/plugins/cors.yaml

# Configure the Service Monitor
kubectl apply -f kong/service-monitor.yaml

# Create services and routes
kubectl apply -f kong/services/services-routes.yaml
```

### Step 4: JWT Configuration

To configure JWT for consumers in Kong, use the following commands:

```bash
# Port-forward Kong Admin
kubectl port-forward service/kong-kong-admin 2343:8001 -n kong

# Create a consumer and its JWT credentials
curl -i -X POST http://localhost:2343/consumers/ --data "username=kong"
curl -i -X POST http://localhost:2343/consumers/kong/jwt --data "key=kong-jwt" --data "secret=kong-jwt-secret-5dMIdKChUaejehAekD48tvJMdsIgP6Lgm0pfsE"
```

### Step 5: Access Konga

To access **Konga**, use the following port-forward command:

```bash
kubectl port-forward service/konga-service 8090:80 -n kong
```

Now, you can access the Konga UI at `http://localhost:8090` and connect to Kong Admin using:

- URL: `http://kong-kong-admin.kong.svc.cluster.local:8001`

## 📘 Helmfile Configuration

Deploy Kong, Konga, and PostgreSQL automatically using **Helmfile** by running:

```bash
helmfile apply # or sync
```

## 🎯 Observability and Monitoring

This Kong stack includes observability support via Prometheus, Grafana, and Loki, enabling you to monitor logs and metrics effectively.

## 📜 License

This project is licensed under the MIT License. See the LICENSE file for details.