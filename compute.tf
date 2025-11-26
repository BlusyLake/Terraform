# --- Buscar Imagem Ubuntu (Agnóstico a região) ---
data "oci_core_images" "ubuntu_latest" {
  compartment_id   = var.compartment_id
  operating_system = "Canonical Ubuntu"
  shape            = var.instance_shape
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

# --- Buscar Data Center Disponível ---
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# --- A Instância ---
resource "oci_core_instance" "server" {
  # Pega o primeiro AD disponível
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "${var.project_name}-Server"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_latest.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}
