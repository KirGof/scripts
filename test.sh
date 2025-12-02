#!/bin/bash
# mkdir -p main standin res

# Генерируем 50 конфигов для main (system_3 - system_52)
for i in {3..52}; do
    cat > "main/system_${i}.conf" << EOF
server {
    listen 80;
    server_name system_${i};
    
    location / {
        proxy_pass http://system_${i}_main:8080;
        proxy_set_header Host \$host;
    }
}
EOF
done

# Генерируем 50 конфигов для standin
for i in {3..52}; do
    cat > "standin/system_${i}.conf" << EOF
server {
    listen 80;
    server_name system_${i};
    
    location / {
        proxy_pass http://system_${i}_standin:8081;
        proxy_set_header Host \$host;
    }
}
EOF
done
