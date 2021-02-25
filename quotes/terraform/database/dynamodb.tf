resource "aws_dynamodb_table" "global" {
  count = var.dynamodb_global ? 1 : 0
  hash_key         = var.dynamodb_hash_key
  name             = "${local.resource_correlation_id}"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode = "PAY_PER_REQUEST"

  dynamic "global_secondary_index" {
    for_each = var.dynamodb_global_secondary_indexes
    content {
      name = global_secondary_index.value.name
      hash_key = global_secondary_index.value.hash_key
      range_key = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      non_key_attributes = sort(global_secondary_index.value.non_key_attributes)
    }
  }

  dynamic "attribute" {
    for_each = var.dynamodb_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "replica" {
    for_each = var.aws_regions
    content {
      region_name = replica.value
    }
  }
}

resource "aws_dynamodb_table" "single" {
  count = var.dynamodb_global ? 0 : 1
  hash_key         = var.dynamodb_hash_key
  name             = local.resource_correlation_id
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode = "PAY_PER_REQUEST"

  dynamic "global_secondary_index" {
    for_each = var.dynamodb_global_secondary_indexes
    content {
      name = global_secondary_index.value.name
      hash_key = global_secondary_index.value.hash_key
      range_key = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      non_key_attributes = sort(global_secondary_index.value.non_key_attributes)
    }
  }

  dynamic "attribute" {
    for_each = var.dynamodb_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}
