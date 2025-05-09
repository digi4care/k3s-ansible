# Kubernetes HA Example Configurations

This directory contains example configurations for different High Availability Kubernetes scenarios. Each example is optimized for specific use cases and demonstrates different approaches to load balancing and high availability.

## Available Examples

### 1. CMS High Availability (`cms-ha/`)
Optimized for Content Management Systems requiring stable IP addresses.

**Key Features:**
- Uses kube-vip for both control plane and service load balancing
- Calico CNI for enhanced network policies
- Dedicated IP ranges for frontend (192.168.30.150-155) and admin (192.168.30.156-160)
- Moderate resource requirements (4GB control plane, 8GB workers)

**Best For:**
- Content Management Systems
- Documentation platforms
- Static content delivery
- Small to medium traffic websites

### 2. E-commerce with MetalLB (`ecommerce-metallb/`)
Optimized for high-traffic e-commerce platforms requiring maximum performance.

**Key Features:**
- MetalLB for service load balancing with dedicated pools
- Cilium CNI for optimal performance
- Separate IP ranges for frontend (192.168.30.210-215) and backend (192.168.30.216-220)
- Higher resource allocation (8GB control plane, 16GB workers)

**Best For:**
- High-traffic online stores
- Dynamic web applications
- Applications requiring traffic spike handling
- Performance-critical services

### 3. E-commerce High Availability (`ecommerce-ha/`)
Optimized for mission-critical e-commerce requiring maximum stability.

**Key Features:**
- kube-vip for all load balancing needs
- Calico CNI for network policies and security
- Dedicated IP ranges for frontend (192.168.30.251-255), API (192.168.30.240-245), and admin (192.168.30.246-249)
- High resource allocation (8GB control plane, 16GB workers)
- Predictable failover behavior

**Best For:**
- Mission-critical online stores
- Financial services applications
- Systems requiring audit trails
- Environments where stability is paramount

### 4. Hybrid Load Balancing (`hybrid-lb/`)
Demonstrates using both kube-vip and MetalLB for different service types.

**Key Features:**
- Hybrid setup with both kube-vip and MetalLB
- Cilium CNI with advanced networking features
- BGP enabled for MetalLB routing
- Segregated ranges: kube-vip (192.168.30.160-170) and MetalLB (192.168.30.180-190)
- High resource allocation (8GB control plane, 16GB workers)
- Dashboard enabled for monitoring

**Best For:**
- Mixed workload environments
- Microservices architectures
- Complex applications with varying requirements
- Development/testing environments

## Usage

1. Choose the appropriate example based on your needs:
   ```bash
   # For CMS deployments
   ansible-playbook site.yml -i inventory/cms-ha/

   # For high-traffic e-commerce
   ansible-playbook site.yml -i inventory/ecommerce-metallb/

   # For stable e-commerce
   ansible-playbook site.yml -i inventory/ecommerce-ha/

   # For mixed workloads
   ansible-playbook site.yml -i inventory/hybrid-lb/
   ```

2. Before deployment, ensure:
   - All node IPs in `hosts.ini` are correct and reachable
   - Network ranges (192.168.30.x) match your environment
   - Nodes meet the specified resource requirements
   - Required ports are open in your network

## Load Balancer Comparison

### kube-vip
- **Pros:**
  - Stable, predictable IP addresses
  - Simple to manage
  - Lower resource overhead
  - Good for static workloads
- **Cons:**
  - Basic load balancing features
  - Limited traffic distribution options

### MetalLB
- **Pros:**
  - Advanced traffic distribution
  - Better performance for high traffic
  - More mature monitoring
  - Better connection draining
- **Cons:**
  - More complex setup
  - Higher resource usage
  - Requires more planning

## Resource Requirements

Each example has different resource requirements based on its use case:

| Example | Control Plane | Workers | Use Case |
|---------|--------------|---------|-----------|
| cms-ha | 4GB RAM, 2 CPU | 8GB RAM, 4 CPU | Content Management |
| ecommerce-metallb | 8GB RAM, 4 CPU | 16GB RAM, 8 CPU | High Traffic |
| ecommerce-ha | 8GB RAM, 4 CPU | 16GB RAM, 8 CPU | Mission Critical |
| hybrid-lb | 8GB RAM, 4 CPU | 16GB RAM, 8 CPU | Mixed Workloads |

## Network Planning

Each example uses different IP ranges for services:

- Control Plane VIPs: 192.168.30.100-150
- CMS Services: 192.168.30.150-160
- E-commerce MetalLB: 192.168.30.210-220
- E-commerce HA: 192.168.30.240-255
- Hybrid Services: 192.168.30.160-190

Ensure these ranges don't conflict with your existing network infrastructure.
