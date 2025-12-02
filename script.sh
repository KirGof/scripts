#!/bin/bash

set -e

for SYS in $(yq '.systems | keys[]' systems.yaml | tr -d '"'); do
    STATUS_MAIN=$(yq ".systems.${SYS}.main" systems.yaml | tr -d '"')
    STATUS_STANDIN=$(yq ".systems.${SYS}.standin" systems.yaml | tr -d '"')
    
    # echo "Система: $SYS main: $STATUS_MAIN standin: $STATUS_STANDIN"
    
    if [ "$STATUS_MAIN" = "true" ] && [ "$STATUS_STANDIN" = "true" ]; then
        echo "ОШИБКА: $SYS - оба контура активны!" >&2
        exit 1
    elif [ "$STATUS_MAIN" = "false" ] && [ "$STATUS_STANDIN" = "false" ]; then
        echo "ОШИБКА: $SYS - оба контура неактивны!" >&2
        exit 1
    fi
    
    if [ "$STATUS_MAIN" = "true" ]; then
        if [ ! -f "main/${SYS}.conf" ]; then
            echo "ОШИБКА: main/${SYS}.conf не существует!" >&2
            exit 1
        fi
        cp "main/${SYS}.conf" "res/${SYS}.conf"
        echo "используется main/${SYS}.conf"
    else
        if [ ! -f "standin/${SYS}.conf" ]; then
            echo "ОШИБКА: standin/${SYS}.conf не существует!" >&2
            exit 1
        fi
        cp "standin/${SYS}.conf" "res/${SYS}.conf"
        echo "используется standin/${SYS}.conf"
    fi
done
