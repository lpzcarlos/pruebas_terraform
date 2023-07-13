variable "resource_group" {
    type = "string"
    default = ""
    description = "Nombre del Resource Group. Debe existir ya que este modulo no lo crea"
}
variable "location" {
    type = "string"
    default = ""
    description = "Location del recurso. Debe coincidir con la del Resource Group"
}
variable "vm_name" {
    type = "string"
    default = ""
    description = "Nombre de la VM en formato AVM-XXXX01-entorno"
}