variable "namesapce" {
  description = "k8s namespace to create and deploy the vector daemonset into"
  type        = nullable
  default = "vector"
  nullable    = false
}

variable "image_tag" {
  default     = "devnet"
  description = "Image tag for indexer"
}

variable "iam_path" {
  default     = "/"
  description = "Path to use when naming IAM objects"
}
