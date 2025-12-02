#!/bin/bash
set -e

CONTEXT="systems"

eval "$(yq -r ".$CONTEXT | to_entries[] | \"MAIN_\(.key)='\(.value.main)'; STANDIN_\(.key)='\(.value.standin)';\"" systems.yaml)"

for SYS in $(yq -r ".$CONTEXT | keys[]" systems.yaml | tr -d '"'); do
    STATUS_MAIN="MAIN_${SYS}"
    STATUS_STANDIN="STANDIN_${SYS}"
    
    if [ "${!STATUS_MAIN}" = "true" ] && [ "${!STATUS_STANDIN}" = "true" ]; then
        echo "ОШИБКА: $SYS - оба контура активны!" >&2
        exit 1
    elif [ "${!STATUS_MAIN}" = "false" ] && [ "${!STATUS_STANDIN}" = "false" ]; then
        echo "ОШИБКА: $SYS - оба контура неактивны!" >&2
        exit 1
    fi

    if [ "${!STATUS_MAIN}" = "true" ]; then
        [ -f "main/${SYS}.conf" ] || { echo "ОШИБКА: main/${SYS}.conf не существует!" >&2; exit 1; }
        cp "main/${SYS}.conf" "res/${SYS}.conf"
        echo "используется main/${SYS}.conf"
    else
        [ -f "standin/${SYS}.conf" ] || { echo "ОШИБКА: standin/${SYS}.conf не существует!" >&2; exit 1; }
        cp "standin/${SYS}.conf" "res/${SYS}.conf"
        echo "используется standin/${SYS}.conf"
    fi
done
