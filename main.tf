terraform {

  required_version = "= 1.4.6"



  required_providers {

    yandex = {

      source = "yandex-cloud/yandex"

      version = "= 0.73"

    }

  }
backend "s3" {

  endpoint   = "storage.yandexcloud.net"

  bucket     = "tf-state-bucket-debian"

  region     = "ru-central1-a"

  key        = "terraform/infrastructure/terraform.tfstate"

  access_key = "YCAJED3ukYzhFyeleUi_TFS64"

  secret_key = "YCOkhv5tQMXTWkjTUmHVxu2VEoPNklNiOFCg3ngX"

 

  skip_region_validation      = true

  skip_credentials_validation = true

  }
}



provider "yandex" {

  token = "y0_AgAAAAA8VnWNAATuwQAAAADjYhit6VNz5OIvT8KPDehVIe8Ht4MuFqE"

  cloud_id = "b1g4vg6ffpqfmmu72eii"

  folder_id = var.yandex_folder_id

  zone = "ru-central1-a"

}


resource "yandex_compute_instance" "vm-debian" {

  name = "terraform-debian"

  allow_stopping_for_update = true

  resources {

    cores = 4

    memory = 4

  }

  boot_disk {

    initialize_params {

      image_id = "fd836i84upn7i2rsjvu2"

    }

  }

  network_interface {

    subnet_id = yandex_vpc_subnet.subnet_terraform.id

    nat = true

  }

  metadata = {

    user-data = "${file("./meta.yml")}"

  }

}

resource "yandex_vpc_network" "network_terraform" {

  name = "network_terraform"

}

resource "yandex_vpc_subnet" "subnet_terraform" {

  name = "subnet_terraform"

  zone = "ru-central1-a"

  network_id = yandex_vpc_network.network_terraform.id

  v4_cidr_blocks = ["192.168.15.0/24"]
}

