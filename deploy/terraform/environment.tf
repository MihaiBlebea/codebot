variable "do_token" {
    description = "Digital ocean auth token"
}

variable "cluster_name" {
    description = "Name of the digital ocean kubernetes cluster"
    default     = "mihaiblebea-platform-cluster"
}

variable "http_port" {
    description = "Pod HTTP port"
    default     = 8080
}

variable "node_port" {
    default = 30002
}

variable "codebot_image" {}

variable "slack_token" {}

variable "witai_token" {}