# --- VCN (Rede Principal) ---
resource "oci_core_vcn" "main_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-VCN"
  dns_label      = "blusyvcn"
}

# --- Gateway de Internet ---
resource "oci_core_internet_gateway" "main_ig" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "${var.project_name}-Internet-Gateway"
}

# --- Tabela de Rotas ---
resource "oci_core_route_table" "main_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "${var.project_name}-Route-Table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main_ig.id
  }
}

# --- Firewall (Security List) ---
resource "oci_core_security_list" "main_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "${var.project_name}-Security-List"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Regras Dinâmicas (SSH, HTTP, HTTPS)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "SSH Access"
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTP Web"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTPS Web"
    tcp_options {
      min = 443
      max = 443
    }
  }
}

# --- Subnet Pública ---
resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "10.0.1.0/24"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main_vcn.id
  display_name      = "${var.project_name}-Public-Subnet"
  route_table_id    = oci_core_route_table.main_rt.id
  security_list_ids = [oci_core_security_list.main_sl.id]
}
