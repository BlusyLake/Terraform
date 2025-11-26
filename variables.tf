# --- Identificação ---
variable "compartment_id" {
  description = "OCID do compartimento onde tudo será criado"
  type        = string
}

variable "project_name" {
  description = "Prefixo para nomear os recursos (Ex: Prod, Dev)"
  type        = string
  default     = "Padrao"
}

# --- Acesso ---
variable "ssh_public_key" {
  description = "Chave pública para acessar as VMs"
  type        = string
}

# --- Hardware (Shape) ---
variable "instance_shape" {
  description = "Qual hardware usar? (Padrão: Ampere ARM Grátis)"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  default = 4
}

variable "instance_memory" {
  default = 24
}

