terraform {
    required_version = "0.13.5"

    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 1.22.0"
        }
    }
    
    backend "remote" {
        organization = "PurpleTreeTech"

        workspaces {
            name = "codebot" // Add workspace to the terraform cloud
        }
    }
}

provider "digitalocean" {
    token   = var.do_token
    version = "1.22.0"
}

data "digitalocean_kubernetes_cluster" "platform_cluster" {
    name = var.cluster_name
}

provider "kubernetes" {
    load_config_file       = false
    host                   = data.digitalocean_kubernetes_cluster.platform_cluster.endpoint
    token                  = data.digitalocean_kubernetes_cluster.platform_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
        data.digitalocean_kubernetes_cluster.platform_cluster.kube_config[0].cluster_ca_certificate
    )
}

resource "kubernetes_namespace" "codebot" {
    metadata {
        name = "codebot"
    }
}

resource "kubernetes_deployment" "codebot_deployment" {
    metadata {
        name      = "codebot-deployment"
        namespace = "codebot"
        labels    = {
            app  = "go-broadcast"
            name = "codebot-deployment"
        }
    }

    spec {
        replicas = 1

        selector {
            match_labels = {
                app  = "codebot"
                name = "codebot-pod"
            }
        }

        template {
            metadata {
                name   = "codebot-pod"
                labels = {
                    app  = "codebot"
                    name = "codebot-pod"
                }
            }

            spec {
                container {
                    image = var.codebot_image
                    name  = "codebot-container"
                    env {
                        name  = "HTTP_PORT"
                        value = var.http_port
                    }

                    env {
                        name = "SLACK_TOKEN"
                        value = var.slack_token 
                    }

                    env {
                        name = "WITAI_TOKEN"
                        value = var.witai_token
                    }

                    port {
                        container_port = var.http_port
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "codebot_int" {
    metadata {
        name      = "codebot-service"
        namespace = "codebot"
    }

    spec {
        selector = {
            name = "codebot-pod"
        }

        port {
            port        = 80
            target_port = var.http_port
            node_port   = var.node_port
        }

        type = "NodePort"
    }
}

resource "kubernetes_service" "codebot_ext" {
    metadata {
        name      = "codebot-service-ext"
        namespace = "codebot"
    }

    spec {
        selector = {
            name = "codebot-pod"
        }

        port {
            port        = 80
            target_port = var.http_port
        }

        type = "ClusterIP"
    }
}