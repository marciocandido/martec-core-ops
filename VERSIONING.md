# VERSIONING — martec-core-ops

## Regra geral
Este repositório segue versionamento baseado em impacto operacional.

## Tipos de mudança
- feat: nova automação ou script
- fix: correção operacional
- docs: atualização de runbook
- refactor: melhoria sem alteração funcional

## Regras
Toda mudança deve documentar:
- o que mudou
- impacto em backup
- impacto em restore
- impacto em rebuild
- necessidade de validação

## Branches
- main → estado validado
- feat/* → novas automações
- fix/* → correções
- docs/* → documentação
