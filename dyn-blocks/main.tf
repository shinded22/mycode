terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22.0"
    }
  }
}

provider "docker" {}


resource "docker_image" "acme" {
        name         = "nginx:1.23.4"    # if you use the tag "latest" it will bark
        keep_locally = true
}

resource "docker_container" "acme" {
        name  = "tf-test"
        image = "${docker_image.acme.image_id}"
 
# this is a repeating block
  upload {
    content    = "Great news of Rotary to announce" # take this value
    file       = "/terraform/test3.txt"     # upload it to "test1.txt"
    executable = true
  }

  upload {
    content    = "Well done of your performance" # "Good news, everyone!"
    file       = "/terraform/test4.txt" # upload it as "test2.txt"
    executable = true
  }

}


        # visit https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container
        # note that "upload" is a "block set" (the block is "upload" and the "set" are unique "upload" blocks)


# we may provide values for this definition in a tfvars file
#the types are found at https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container
variable "upload_content" {
  description = "list of file data to upload into containers"
  type = list(object({
    content                  = string
    file                     = string
    executable               = bool
  }))
}

