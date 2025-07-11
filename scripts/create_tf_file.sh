#!/bin/bash

# Kiểm tra nếu không có đối số nào được truyền vào
if [ $# -eq 0 ]; then
  echo "❌ Vui lòng truyền ít nhất một đường dẫn thư mục."
  echo "Cách dùng: ./create_tf_files.sh dir1 dir2 dir3 ..."
  exit 1
fi

# Lặp qua tất cả các tham số đầu vào
for TARGET_DIR in "$@"; do
  echo "📁 Đang xử lý: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"

  touch "$TARGET_DIR/main.tf" "$TARGET_DIR/outputs.tf" "$TARGET_DIR/variables.tf" "$TARGET_DIR/terraform.tfvars"

  echo "✅ Đã tạo file tại: $TARGET_DIR"
done
