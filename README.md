## Lệnh triển khai:

```bash
# Khởi tạo Terraform
terraform init

# Xem kế hoạch thay đổi
terraform plan -var-file="terraform.tfvars"

# Triển khai
terraform apply -var-file="terraform.tfvars"

# Xóa infrastructure
terraform destroy -var-file="terraform.tfvars"
```
---
Hướng dẫn cách sử dụng các lệnh Terraform để xem trạng thái của các resource, đặc biệt là khi sử dụng cấu trúc `module`.
---
### 📦 1. Hiển thị toàn bộ Terraform state (bao gồm module con)

```bash
terraform show
```

* Hiển thị toàn bộ thông tin trong Terraform state file.
* Bao gồm tất cả các tài nguyên từ các `module`.
---
### 📋 2. Liệt kê tất cả resource trong state

```bash
terraform state list
```

* Liệt kê toàn bộ resource, bao gồm cả trong module, ví dụ:

```
module.vpc.aws_vpc.main
module.lambda.aws_lambda_function.router
module.api_gateway.aws_api_gateway_rest_api.main
```
---

### 🔍 3. Xem chi tiết một resource cụ thể

```bash
terraform state show module.lambda.aws_lambda_function.router
```
* Hiển thị chi tiết thông tin về resource Lambda `router` trong module `lambda`.
---

### 📤 4. Xem output của Terraform

```bash
terraform output
```
* Hiển thị các giá trị được khai báo trong block `output`.

```bash
terraform output router_function_arn
```
---

### 🔎 5. Tìm resource trong module theo tên

Sử dụng grep để lọc resource từ `terraform state list`:

```bash
terraform state list | grep module.lambda
```
---

## ✅ Note 

* Đảm bảo `terraform apply` hoặc `terraform init` đã được chạy trước khi dùng các lệnh trên.
* Luôn kiểm tra `terraform state list` khi không chắc chắn một module đã được apply chưa.
---


