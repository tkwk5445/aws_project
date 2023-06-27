provider "local" {
}

variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]

}

variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}


output "upper_roles" {
  value = { for name, role1 in var.hero_thousand_faces : upper(name) => upper(role1) }
}


output "upper_names" {
  value = [for name in var.names : upper(name)]
}
