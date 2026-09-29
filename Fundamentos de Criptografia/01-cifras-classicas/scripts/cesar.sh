#!/bin/bash
# Cifra de César
# Uso: ./cesar.sh <deslocamento> "texto"
# Deslocamento negativo = decifrar
export LC_ALL=C
ALFA=ABCDEFGHIJKLMNOPQRSTUVWXYZ
k=$(( ($1 % 26 + 26) % 26 ))
DESL="${ALFA:$k}${ALFA:0:$k}"
echo "$2" | tr 'a-z' 'A-Z' | tr "$ALFA" "$DESL"
