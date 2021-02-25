variable "application_name" {
    type = string
    description = "Name of application these resources are used for"
}

variable "application_lifecycle" {
    type = string
    description = "Phase of the application's SDLC these resources are used for"
}

variable "aws_regions" {
    type = list(string)
    default = [
      "us-east-1",
      "eu-central-1"
    ]
}

variable "dynamodb_endpoint" {
    default = "https://dynamodb.us-east-2.amazonaws.com"
}

variable "skip_credentials_validation" {
    default = false
}
variable "skip_metadata_api_check" {
    default = false
}
variable "skip_requesting_account_id" {
    default = false
}

variable "dynamodb_hash_key" {
    default = "id"
}

variable "dynamodb_global" {
    default = true
}

variable "dynamodb_attributes" {
    default = [
        {
            name = "id"
            type = "S"
        },
        {
            name = "createDate"
            type = "S"
        }
    ]
}

variable "dynamodb_global_secondary_indexes" {
    default = [
        {
            name               = "CreateDate"
            hash_key           = "createDate"
            range_key          = "id"
            projection_type    = "INCLUDE"
            non_key_attributes = [
                "id",
                "createDate",
                "quote"
            ]
        }
    ]
}
