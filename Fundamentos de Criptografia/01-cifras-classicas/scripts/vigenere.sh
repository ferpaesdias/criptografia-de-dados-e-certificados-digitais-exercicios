#!/bin/bash
# Cifra de Vigenère
# Uso: ./vigenere.sh cifrar|decifrar CHAVE "texto"
export LC_ALL=C
modo=$1; chave=${2^^}; texto=${3^^}
if [[ ! $chave =~ ^[A-Z]+$ ]]; then echo "Chave deve conter apenas letras A-Z"; exit 1; fi
saida=""; j=0
for (( i=0; i<${#texto}; i++ )); do
  c=${texto:i:1}
  if [[ $c == [A-Z] ]]; then
    k=$(( $(printf '%d' "'${chave:j%${#chave}:1}") - 65 ))
    [[ $modo == decifrar ]] && k=$(( 26 - k ))
    p=$(( $(printf '%d' "'$c") - 65 ))
    saida+=$(printf "\\$(printf '%03o' $(( (p + k) % 26 + 65 )))")
    j=$(( j + 1 ))
  else
    saida+=$c
  fi
done
echo "$saida"
