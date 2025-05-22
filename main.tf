terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.105.0"
    }
  }
  required_version = ">= 1.0.0"
}


provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}


# Создание сервисного аккаунта
resource "yandex_iam_service_account" "s3_sa" {
  name        = "s3-service-account"
  description = "Service account for S3 bucket management"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa_editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.s3_sa.id}"
}

# Создание статических ключей доступа
resource "yandex_iam_service_account_static_access_key" "sa_keys" {
  service_account_id = yandex_iam_service_account.s3_sa.id
}

# Создание S3 бакета
resource "yandex_storage_bucket" "s3_bucket" {
  bucket     = var.bucket_name
  acl        = var.bucket_acl
  access_key = yandex_iam_service_account_static_access_key.sa_keys.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_keys.secret_key
}
