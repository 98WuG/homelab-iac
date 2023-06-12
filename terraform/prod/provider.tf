# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }
}
provider "proxmox" {
  pm_api_url          = var.proxmox.api_url
  pm_api_token_id     = var.proxmox.api_token_id
  pm_api_token_secret = var.proxmox.api_token_secret
}
provider "kubernetes" {
  config_path = var.kubernetes.config_path
}
provider "helm" {
  kubernetes {
    config_path = var.kubernetes.config_path
  }
}
