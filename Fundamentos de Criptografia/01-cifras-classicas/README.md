# Laboratório 01 — Cifras clássicas no Debian

**Cifra de César e Cifra de Vigenère**

| | |
|---|---|
| **Unidade** | UC13 — Planejar e implementar a criptografia de dados e certificados digitais |
| **Duração** | 3h30 |
| **Ambiente** | Debian, terminal, usuário comum com `sudo` |
| **Objetivo** | Compreender na prática os conceitos de chave, algoritmo e criptografia simétrica, e perceber por que as cifras clássicas são fracas, preparando o estudo de algoritmos modernos como o AES. |

## Sumário

- [Parte 0 — Preparação](#parte-0--preparação-10-min)
- [Parte 1 — César no papel](#parte-1--césar-no-papel-20-min)
- [Parte 2 — César com o comando tr](#parte-2--césar-com-o-comando-tr-20-min)
- [Parte 3 — Script de César com chave variável](#parte-3--script-de-césar-com-chave-variável-25-min)
- [Parte 4 — Quebrando César por força bruta](#parte-4--quebrando-césar-por-força-bruta-20-min)
- [Parte 5 — Análise de frequência, em duplas](#parte-5--análise-de-frequência-em-duplas-30-min)
- [Parte 6 — Vigenère no papel](#parte-6--vigenère-no-papel-25-min)
- [Parte 7 — Script de Vigenère](#parte-7--script-de-vigenère-30-min)
- [Parte 8 — Comparando César e Vigenère](#parte-8--comparando-césar-e-vigenère-20-min)
- [Parte 9 — Reflexão e fechamento](#parte-9--reflexão-e-fechamento-20-min)

Registre as respostas dos exercícios no seu relatório.

---

## Parte 0 — Preparação (10 min)

Crie a pasta de trabalho:

```bash
mkdir -p ~/lab-cifras && cd ~/lab-cifras
```

Todos os comandos usados pertencem ao **coreutils** e ao **bash** e já vêm instalados no Debian.

> [!IMPORTANT]
> **Combinado da turma:** use textos sem acentos e sem "ç" (ex.: SEGURANCA, INFORMACAO).

---

## Parte 1 — César no papel (20 min)

A cifra de César substitui cada letra por outra, deslocada **k** posições no alfabeto. A chave é o próprio **k**.

```
Claro:  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
k = 3:  D E F G H I J K L M N O P Q R S T U V W X Y Z A B C
```

> **Exercício 1.1** — Cifre à mão, com k = 3: `REDES DE COMPUTADORES`

> **Exercício 1.2** — Decifre à mão (k = 3): `FULSWRJUDILD`

> **Exercício 1.3** — Quantas chaves possíveis existem na cifra de César? Por que k = 26 não serve?

---

## Parte 2 — César com o comando tr (20 min)

O `tr` troca caracteres de um conjunto pelos de outro. Para César com k = 3:

```bash
echo "ATAQUE AO AMANHECER" | tr 'A-Z' 'D-ZA-C'
```

Para decifrar, invertemos os conjuntos:

```bash
echo "DWDTXH DR DPDQKHFHU" | tr 'D-ZA-C' 'A-Z'
```

> **Exercício 2.1** — Confira com o `tr` suas respostas da Parte 1.

> **Exercício 2.2** — Monte o comando `tr` para k = 5 e cifre seu nome completo.

> **Exercício 2.3** — **ROT13** é César com k = 13. Execute o comando abaixo, depois passe a saída de novo pelo mesmo comando. O que acontece? Explique por que isso ocorre só com k = 13.

```bash
echo "Redes" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
```

---

## Parte 3 — Script de César com chave variável (25 min)

Crie o arquivo `cesar.sh` com `nano cesar.sh` e digite:

```bash
#!/bin/bash
# Uso: ./cesar.sh <deslocamento> "texto"
# Deslocamento negativo = decifrar
export LC_ALL=C
ALFA=ABCDEFGHIJKLMNOPQRSTUVWXYZ
k=$(( ($1 % 26 + 26) % 26 ))
DESL="${ALFA:$k}${ALFA:0:$k}"
echo "$2" | tr 'a-z' 'A-Z' | tr "$ALFA" "$DESL"
```

Dê permissão de execução e teste:

```bash
chmod +x cesar.sh
./cesar.sh 3 "ataque ao amanhecer"
./cesar.sh -3 "DWDTXH DR DPDQKHFHU"
```

> [!TIP]
> Se o script não funcionar, compare com a versão de referência deste repositório: [`scripts/cesar.sh`](scripts/cesar.sh).

> **Exercício 3.1** — Explique com suas palavras o que a linha `DESL=...` faz. Dica: rode `echo ${ALFA:3}` e `echo ${ALFA:0:3}` separadamente.

> **Exercício 3.2** — Por que a conta `($1 % 26 + 26) % 26` é necessária para chaves negativas? Teste com -3 e com -29.

---

## Parte 4 — Quebrando César por força bruta (20 min)

Com apenas 25 chaves possíveis, basta testar todas:

```bash
for k in $(seq 1 25); do
  echo "k=$k: $(./cesar.sh -$k 'ZLNBYHUJH KH PUMVYTHJHV')"
done
```

> **Exercício 4.1** — Qual é a mensagem? Qual foi a chave usada?

> **Exercício 4.2** — Quanto tempo o computador levou? Use `time` antes do laço. O que isso diz sobre a segurança da cifra?

---

## Parte 5 — Análise de frequência, em duplas (30 min)

Em português, as letras mais frequentes são **A, E e O**, nessa ordem aproximada.

1. Cada aluno escreve um texto de pelo menos 5 linhas em `claro.txt`, sem acentos.
2. Cifre-o com uma chave secreta escolhida por você:
   ```bash
   ./cesar.sh 11 "$(cat claro.txt)" > cifrado.txt
   ```
3. Envie **apenas** o `cifrado.txt` ao colega (pode usar `scp` se estiverem em rede).
4. O colega conta as letras do arquivo recebido:
   ```bash
   tr -cd 'A-Z' < cifrado.txt | fold -w1 | sort | uniq -c | sort -rn | head -5
   ```

> **Exercício 5.1** — Supondo que a letra mais frequente corresponde a "A", calcule a chave e decifre sem usar força bruta.

> **Exercício 5.2** — O método funcionou? Se não, suponha que ela é "E" ou "O". Anote quantas tentativas foram necessárias.

> [!NOTE]
> **Extra opcional:** o pacote `bsdgames` traz um utilitário que faz essa análise automaticamente:
> ```bash
> sudo apt install bsdgames
> /usr/games/caesar < cifrado.txt
> ```

---

## Parte 6 — Vigenère no papel (25 min)

A cifra de Vigenère usa uma **palavra-chave**. Cada letra da chave define um deslocamento diferente (A = 0, B = 1, …, Z = 25), e a chave se repete ao longo do texto.

```
Claro:  A T A Q U E A O A M A N H E C E R
Chave:  L I M A O L I M A O L I M A O L I
Cifra:  L B M Q I P I A A A L V T E Q P Z
```

Assim, A + L (11) = L, T + I (8) = B, e assim por diante.

> **Exercício 6.1** — Gere a tabela de Vigenère (*tabula recta*) no terminal e use-a como apoio:
> ```bash
> ALFA=ABCDEFGHIJKLMNOPQRSTUVWXYZ
> for i in $(seq 0 25); do echo "${ALFA:$i}${ALFA:0:$i}"; done
> ```

> **Exercício 6.2** — Cifre à mão `REDES SENAC BIRIGUI` com a chave `SENAC`.

> **Exercício 6.3** — No exemplo acima, a letra "A" do texto claro virou L, M, I e A em posições diferentes. Por que isso atrapalha a análise de frequência?

---

## Parte 7 — Script de Vigenère (30 min)

Crie o arquivo `vigenere.sh`:

```bash
#!/bin/bash
# Uso: ./vigenere.sh cifrar|decifrar CHAVE "texto"
export LC_ALL=C
modo=$1; chave=${2^^}; texto=${3^^}
if [[ ! $chave =~ ^[A-Z]+$ ]]; then
  echo "Chave deve conter apenas letras A-Z"; exit 1
fi
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
```

```bash
chmod +x vigenere.sh
./vigenere.sh cifrar LIMAO "ataque ao amanhecer"
./vigenere.sh decifrar LIMAO "LBMQIP IA AALVTEQPZ"
```

> [!TIP]
> Versão de referência para conferência: [`scripts/vigenere.sh`](scripts/vigenere.sh).

> **Exercício 7.1** — Confira sua resposta do exercício 6.2 com o script.

> **Exercício 7.2** — Decifre a mensagem abaixo, sabendo que a chave é `REDES`:
> `F WHVNZHRV KVVD HWJPLKSUS DW VVD KSJRW`

> **Exercício 7.3** — Para que serve `printf '%d' "'X"`? Teste com `printf '%d\n' "'A"`.

> **Exercício 7.4** — Por que o contador `j` só avança quando o caractere é uma letra?

---

## Parte 8 — Comparando César e Vigenère (20 min)

Use o mesmo `claro.txt` da Parte 5:

```bash
./vigenere.sh cifrar SEGREDO "$(cat claro.txt)" > vig.txt
tr -cd 'A-Z' < cifrado.txt | fold -w1 | sort | uniq -c | sort -rn | head -5
tr -cd 'A-Z' < vig.txt     | fold -w1 | sort | uniq -c | sort -rn | head -5
```

> **Exercício 8.1** — Compare as duas distribuições. Em qual delas a letra mais frequente "se destaca" mais?

> **Exercício 8.2** — Cifre de novo com a chave `A`. O que aconteceu? E com a chave `D`? Relacione com a cifra de César.

---

## Parte 9 — Reflexão e fechamento (20 min)

Responda em grupo e registre no relatório:

> **Exercício 9.1** — César e Vigenère são cifras **simétricas**. Justifique usando o que foi feito no laboratório.

> **Exercício 9.2** — Na Parte 5, como a chave poderia ter sido enviada ao colega de forma segura? Qual problema isso revela? (Ele nos leva à criptografia assimétrica.)

> **Exercício 9.3** — Chaves curtas ou repetidas enfraquecem o Vigenère. Que cuidado equivalente devemos ter com senhas e chaves em cifras modernas, como o AES?

> **Exercício 9.4** — O algoritmo das duas cifras é público e, mesmo assim, só quem tem a chave decifra com facilidade. Pesquise o **Princípio de Kerckhoffs** e relacione.

---

<sub>SENAC São Paulo · Técnico em Redes de Computadores · UC13</sub>
