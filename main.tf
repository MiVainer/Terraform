terraform {

  required_version = "= 1.4.6"



  required_providers {

    yandex = {

      source = "yandex-cloud/yandex"

      version = "= 0.73"

    }

  }

}



provider "yandex" {

  token = "y0_AgAAAAA8VnWNAATuwQAAAADjYhit6VNz5OIvT8KPDehVIe8Ht4MuFqE"

  cloud_id = "b1g4vg6ffpqfmmu72eii"

  folder_id = "b1gppd4nkf0vv6ldlbod"

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

