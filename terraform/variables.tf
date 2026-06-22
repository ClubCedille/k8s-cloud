variable "project_id"{
  type = string
  description = "project id"
}

variable "region" {
  type = string
  description = "region for the project"
}

variable "email_sa" {
  type = string
  description = "email service account. It's a confidential data"
}

variable "ssh_private_key" {
  type = string
  description = "ssh private key. Confidential data, place data in a secret."
}

variable "gcs"{
  type = string
  description = "bucket for tfstate"
}