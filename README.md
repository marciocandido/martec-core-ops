# martec-core-ops

Repositório operacional do MARTEC Core para backup, restore, disaster recovery, rebuild de servidor, bootstrap de Ubuntu, arquivos systemd, exemplos de ambiente e documentação de operação.

## Objetivo
Separar a operação do produto do repositório principal da aplicação.

Este repositório deve concentrar:
- scripts de backup
- scripts de restore
- scripts de bootstrap
- runbooks de disaster recovery
- templates e units do systemd
- exemplos de `.env`
- documentação de impacto operacional por feature

## Estrutura inicial
```text
martec-core-ops/
  README.md
  CHANGELOG.md
  VERSIONING.md
  .gitignore
  /docs
  /scripts
  /systemd
  /env
  /templates
```

## Política operacional
- Não versionar segredos reais.
- Backup sem teste de restore não é confiável.
- Toda feature nova do MARTEC Core deve avaliar impacto operacional neste repositório.
- Qdrant não é a única cópia de verdade.
- PostgreSQL + arquivos oficiais continuam sendo prioridade de recuperação.

## Regra de evolução
A cada mudança relevante, atualizar:
- docs/runbooks
- scripts afetados
- env examples
- units do systemd
- changelog operacional
