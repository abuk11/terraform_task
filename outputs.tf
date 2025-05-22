output "bucket_name" {
  value = yandex_storage_bucket.s3_bucket.bucket
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa_keys.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa_keys.secret_key
  sensitive = true
}