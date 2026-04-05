# Server Bootstrap Ubuntu — MARTEC Core

## Objetivo
Padronizar a preparação de um servidor Ubuntu para o ambiente operacional do MARTEC Core sem uso de Docker nesta fase.

## Decisão atual
- Sem Docker por enquanto
- Scripts, serviços e timers executados diretamente no host
- PostgreSQL e Qdrant tratados como serviços do sistema quando aplicável

## Sequência oficial
1. Atualizar sistema
2. Instalar pacotes base
3. Configurar timezone
4. Instalar cliente PostgreSQL
5. Instalar rclone
6. Criar diretórios operacionais
7. Aplicar permissões nos scripts
8. Instalar units e timers do systemd
9. Validar ambiente

## Comandos iniciais
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip jq rsync tar pigz nano vim htop ca-certificates gnupg lsb-release software-properties-common postgresql-client
sudo timedatectl set-timezone America/Sao_Paulo
```

## Clonar repositório operacional
```bash
git clone git@github.com:marciocandido/martec-core-ops.git
cd martec-core-ops
```

## Permissões dos scripts
```bash
chmod +x scripts/bootstrap/*.sh
chmod +x scripts/backup/*.sh
chmod +x scripts/restore/*.sh
chmod +x scripts/checks/*.sh
chmod +x scripts/permissions/*.sh
```

## Bootstrap por scripts
```bash
bash scripts/bootstrap/00_prepare_ubuntu.sh
bash scripts/bootstrap/02_install_postgres_client.sh
bash scripts/bootstrap/03_install_rclone.sh
bash scripts/bootstrap/04_create_base_dirs.sh
```

## Instalação do systemd
```bash
sudo cp systemd/*.service /etc/systemd/system/
sudo cp systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
```

## Observações
Toda instrução ligada ao servidor deve ser documentada neste repositório.
