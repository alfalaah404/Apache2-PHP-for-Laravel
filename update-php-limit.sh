#!/bin/bash

PHP_INI="/etc/php/8.2/apache2/php.ini"

# Backup file dulu
cp "$PHP_INI" "${PHP_INI}.bak"

# Fungsi untuk mengupdate nilai di php.ini
update_php_ini() {
    local key=$1
    local value=$2
    local file=$3

    if grep -q "^${key}\s*=" "$file"; then
        sed -i "s|^${key}\s*=.*|${key} = ${value}|" "$file"
    else
        echo "${key} = ${value}" >> "$file"
    fi
}

# Set parameter-parameter
update_php_ini "max_execution_time" "600" "$PHP_INI"
update_php_ini "memory_limit" "2G" "$PHP_INI"
update_php_ini "upload_max_filesize" "2G" "$PHP_INI"
update_php_ini "post_max_size" "2G" "$PHP_INI"
update_php_ini "max_input_time" "600" "$PHP_INI"

# Restart apache agar perubahan diterapkan
systemctl restart apache2

echo "PHP configuration updated and Apache restarted."
