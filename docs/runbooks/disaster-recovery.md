# Disaster Recovery — MARTEC Core

## Objetivo
Definir o procedimento completo para reconstrução do ambiente após falha total.

## Princípios
- Não depender de memória humana
- Backup sem restore testado não é confiável
- Restaurar primeiro base operacional, depois dados

## Ordem de prioridade
1. PostgreSQL
2. Arquivos
3. Serviços
4. Qdrant

## Procedimento

### 0. Preparar Ubuntu
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip jq rsync tar pigz nano vim
```

### 1. Criar usuário
```bash
sudo adduser martec
sudo usermod -aG sudo martec
su - martec
```

### 2. Clonar ops
```bash
git clone git@github.com:marciocandido/martec-core-ops.git
cd martec-core-ops
```

### 3. Permissões
```bash
chmod +x scripts/**/*.sh
```

### 4. Bootstrap
```bash
bash scripts/bootstrap/00_prepare_ubuntu.sh
```

### 5. Restore env
```bash
cp env/.env.backup.example .env
nano .env
```

### 6. Restore dados
```bash
bash scripts/restore/10_restore_files.sh
bash scripts/restore/20_restore_postgres.sh
bash scripts/restore/30_restore_qdrant.sh
```

### 7. Reativar serviços
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now martec-backup.timer
```

### 8. Validar
```bash
bash scripts/checks/healthcheck_local.sh
```

## Observação
Qdrant pode ser recriado se necessário.
