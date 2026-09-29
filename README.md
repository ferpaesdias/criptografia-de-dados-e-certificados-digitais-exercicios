# Criptografia de Dados e Certificados Digitais - Exercícios

Exercícios práticos da **UC13 — Planejar e implementar a criptografia de dados e certificados digitais**, do curso **Técnico em Redes de Computadores**.

Os laboratórios são feitos no terminal do **Debian**, com ferramentas nativas do sistema, e seguem a ordem das aulas: primeiro os fundamentos e os métodos manuais, depois as ferramentas de criptografia modernas e os certificados digitais.

## Conteúdo

| Tópico | Laboratório | Duração |
|---|---|---|
| [Fundamentos de Criptografia](Fundamentos%20de%20Criptografia/) | [01 — Cifras clássicas: César e Vigenère](Fundamentos%20de%20Criptografia/01-cifras-classicas/) | 3h30 |

## Como usar este repositório

Instale o Git e clone o repositório no Debian:

```bash
sudo apt update && sudo apt install -y git
git clone <URL-DO-REPOSITORIO>
cd criptografia-de-dados-e-certificados-digitais-exercicios
```

Os nomes das pastas de tópico têm espaços. No terminal, use aspas ou a tecla <kbd>Tab</kbd> para completar:

```bash
cd "Fundamentos de Criptografia/01-cifras-classicas"
```

## Ambiente

- Debian (recomendado: versão estável atual), com acesso ao terminal
- Usuário comum com permissão de `sudo`
- Ferramentas do `coreutils` e do `bash`, já instaladas por padrão

## Estrutura

```
.
├── README.md
└── Fundamentos de Criptografia/
    ├── README.md
    └── 01-cifras-classicas/
        ├── README.md          ← roteiro do laboratório
        ├── scripts/           ← scripts de referência para conferência
        └── exemplos/          ← textos de apoio
```
