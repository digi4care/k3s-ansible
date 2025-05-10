# Ansible Playbook for Kubernetes Cluster Deployment

This Ansible playbook automates the deployment of a production-ready Kubernetes cluster using kubeadm. It supports both single control-plane and high-availability setups, with full integration for Proxmox LXC containers.

## What This Playbook Does

1. **Prepares All Nodes**:
   - Installs required system packages
   - Configures kernel modules and sysctl parameters
   - Sets up container runtime (containerd)

2. **Configures Control Plane**:
   - Initializes Kubernetes control plane with kubeadm
   - Sets up high-availability if multiple control plane nodes
   - Configures networking (Flannel CNI)

3. **Joins Worker Nodes**:
   - Automatically joins workers to the cluster
   - Verifies node status

## Features

- **High Availability**: Multi-node control plane with automatic failover
- **Container Runtime**: Pre-configured containerd with systemd cgroup driver
- **Network Plugin**: Flannel CNI for pod networking
- **Proxmox Integration**: Full support for Proxmox LXC containers
- **Security**: Follows Kubernetes security best practices

## Supported Systems

- **Operating Systems**:
  - Debian 11+
  - Ubuntu 22.04+

- **Architecture**:
  - x86_64 (amd64)

## Requirements

- Ansible 2.11 or higher
- SSH access to target nodes
- Sudo privileges on target nodes
- Python 3 on target nodes

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/digi4care/kubernetes-ansible.git
   cd kubernetes-ansible
   ```

2. Copy and edit the inventory template:
   ```bash
   cp -r inventory/sample inventory/my-cluster
   ```

3. Edit the inventory with your node details:
   ```ini
   # inventory/my-cluster/hosts.ini
   [control_plane]    # Kubernetes control plane nodes
   192.168.1.10      # Primary control plane
   192.168.1.11      # Additional control plane (optional)
   192.168.1.12      # Additional control plane (optional)

   [worker]          # Kubernetes worker nodes
   192.168.1.21      # Worker node 1
   192.168.1.22      # Worker node 2
   192.168.1.23      # Worker node 3

   [k8s_cluster:children]
   control_plane
   worker
   ```

4. Deploy the cluster:
   ```bash
   ansible-playbook site.yml -i inventory/my-cluster/hosts.ini
   ```

5. To reset the cluster:
   ```bash
   ansible-playbook reset.yml -i inventory/my-cluster/hosts.ini
   ```

## Configuration

### Network Configuration

- Pod Network CIDR: 10.244.0.0/16 (Flannel default)
- Service CIDR: 10.96.0.0/12 (Kubernetes default)

### High Availability Setup

When multiple nodes are in the `control_plane` group, the playbook automatically configures:
- Multi-node etcd cluster
- Multiple API server endpoints
- Control plane certificates
- Load balancing between control plane nodes

### Proxmox LXC Configuration

For Proxmox LXC containers, ensure:
1. Nesting is enabled
2. Container has proper privileges
3. Proxmox host is in the `[proxmox]` group

## Post-Installation

1. The kubeconfig file is saved in `./kubeconfig` in the playbook directory
2. Copy it to your local machine:
   ```bash
   cp kubeconfig ~/.kube/config
   ```

3. Verify the cluster:
   ```bash
   kubectl get nodes
   kubectl get pods -A
   ```

## Maintenance

### Adding Worker Nodes

1. Add the new node to your inventory under the `[worker]` group
2. Run the playbook again:
   ```bash
   ansible-playbook site.yml -i inventory/my-cluster/hosts.ini
   ```

### Upgrading Kubernetes

1. Update `kubernetes_version` in `roles/kubernetes_packages/defaults/main.yml`
2. Run the playbook with the upgrade tag:
   ```bash
   ansible-playbook site.yml -i inventory/my-cluster/hosts.ini --tags upgrade
   ```

## Troubleshooting

1. Check node status:
   ```bash
   kubectl get nodes
   ```

2. Check system pods:
   ```bash
   kubectl get pods -n kube-system
   ```

3. View pod logs:
   ```bash
   kubectl logs -n kube-system <pod-name>
   ```

## Reset Cluster

To reset the cluster:
```bash
ansible-playbook reset.yml -i inventory/my-cluster/hosts.ini
```

## License

MIT License

