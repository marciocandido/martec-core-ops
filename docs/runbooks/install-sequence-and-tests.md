# Install Sequence and Tests — MARTEC Core Ops

## Objetivo
Definir a sequência oficial de instalação do ambiente operacional no servidor Ubuntu e os testes que devem ser executados após cada etapa.

## Escopo atual
- Sem Docker
- Execução direta no host
- Foco em backup, restore, bootstrap e automações operacionais

## Pré-requisitos
- Ubuntu acessível via terminal
- usuário com sudo
- acesso ao repositório `martec-core-ops`
- acesso ao repositório principal quando necessário
- credenciais reais guardadas fora do Git

## Sequência oficial de instalação

### Etapa 1 — Clonar o repositório operacional
```bash
git clone git@github.com:marciocandido/martec-core-ops.git
cd martec-core-ops
```

### Teste da etapa 1
```bash
pwd
ls -la
find . -maxdepth 3 -type f | sort
```

Resultado esperado:
- repositório clonado com sucesso
- diretórios `docs`, `scripts`, `env` e `systemd` visíveis

---

### Etapa 2 — Aplicar permissões de execução
```bash
chmod +x scripts/bootstrap/*.sh
chmod +x scripts/backup/*.sh
chmod +x scripts/restore/*.sh
chmod +x scripts/checks/*.sh
chmod +x scripts/permissions/*.sh
```

### Teste da etapa 2
```bash
find scripts -type f -name "*.sh" -exec ls -l {} \;
```

Resultado esperado:
- scripts com permissão executável

---

### Etapa 3 — Preparar o Ubuntu
```bash
bash scripts/bootstrap/00_prepare_ubuntu.sh
```

### Teste da etapa 3
```bash
uname -a
cat /etc/os-release
which git curl wget jq rsync tar pigz nano vim
 timedatectl
```

Resultado esperado:
- utilitários base disponíveis
- timezone configurado corretamente

---

### Etapa 4 — Instalar cliente PostgreSQL
```bash
bash scripts/bootstrap/02_install_postgres_client.sh
```

### Teste da etapa 4
```bash
which psql
psql --version
which pg_dump
pg_dump --version
```

Resultado esperado:
- `psql` e `pg_dump` instalados

---

### Etapa 5 — Instalar rclone
```bash
bash scripts/bootstrap/03_install_rclone.sh
```

### Teste da etapa 5
```bash
which rclone
rclone version
```

Resultado esperado:
- `rclone` instalado

---

### Etapa 6 — Criar diretórios base
```bash
export BACKUP_ROOT=/opt/backups/martec-core
bash scripts/bootstrap/04_create_base_dirs.sh
```

### Teste da etapa 6
```bash
ls -la /opt/backups/martec-core
find /opt/backups/martec-core -maxdepth 2 -type d | sort
```

Resultado esperado:
- diretórios `postgres`, `qdrant`, `files` e `logs` criados

---

### Etapa 7 — Preparar arquivo de ambiente
```bash
cp env/.env.example .env
nano .env
```

### Variáveis mínimas a preencher
- `PGHOST`
- `PGPORT`
- `PGDATABASE`
- `PGUSER`
- `PGPASSWORD`
- `BACKUP_ROOT`
- `FILES_SOURCE_DIR`
- `QDRANT_STORAGE_DIR`
- `REMOTE_BACKUP_NAME`
- `RESTIC_REPOSITORY`
- `RESTIC_PASSWORD`

### Teste da etapa 7
```bash
grep -v '^#' .env | sed '/^$/d'
```

Resultado esperado:
- arquivo `.env` preenchido localmente
- nenhum segredo enviado ao Git

---

### Etapa 8 — Testar conectividade PostgreSQL
```bash
set -a
source .env
set +a

psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -c "SELECT current_database(), current_user, now();"
```

Resultado esperado:
- conexão bem-sucedida ao banco

---

### Etapa 9 — Executar backup PostgreSQL manual
```bash
set -a
source .env
set +a

bash scripts/backup/backup_postgres.sh
```

### Teste da etapa 9
```bash
find "$BACKUP_ROOT/postgres" -maxdepth 1 -type f | sort
```

Resultado esperado:
- arquivo `.dump` criado
- arquivo `.sha256` criado

---

### Etapa 10 — Configurar `rclone`
```bash
rclone config
```

### Teste da etapa 10
```bash
rclone listremotes
rclone lsd "$REMOTE_BACKUP_NAME"
```

Resultado esperado:
- remote configurado
- destino remoto acessível

---

### Etapa 11 — Instalar units e timers do systemd
```bash
sudo cp systemd/*.service /etc/systemd/system/
sudo cp systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
```

### Teste da etapa 11
```bash
systemctl list-unit-files | grep martec
```

Resultado esperado:
- units reconhecidas pelo `systemd`

---

### Etapa 12 — Habilitar timers
```bash
sudo systemctl enable --now martec-backup.timer
sudo systemctl enable --now martec-restore-test.timer
```

### Teste da etapa 12
```bash
systemctl list-timers | grep martec
```

Resultado esperado:
- timers ativos
- próxima execução agendada

---

### Etapa 13 — Validar checks locais
```bash
bash scripts/checks/healthcheck_local.sh
bash scripts/checks/verify_backup_artifacts.sh
```

Resultado esperado:
- checks executando sem erro crítico

---

## Ordem resumida
```bash
git clone git@github.com:marciocandido/martec-core-ops.git
cd martec-core-ops
chmod +x scripts/bootstrap/*.sh scripts/backup/*.sh scripts/restore/*.sh scripts/checks/*.sh scripts/permissions/*.sh
bash scripts/bootstrap/00_prepare_ubuntu.sh
bash scripts/bootstrap/02_install_postgres_client.sh
bash scripts/bootstrap/03_install_rclone.sh
export BACKUP_ROOT=/opt/backups/martec-core
bash scripts/bootstrap/04_create_base_dirs.sh
cp env/.env.example .env
nano .env
set -a && source .env && set +a
psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -c "SELECT 1;"
bash scripts/backup/backup_postgres.sh
rclone config
rclone listremotes
sudo cp systemd/*.service /etc/systemd/system/
sudo cp systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now martec-backup.timer
sudo systemctl enable --now martec-restore-test.timer
systemctl list-timers | grep martec
bash scripts/checks/healthcheck_local.sh
bash scripts/checks/verify_backup_artifacts.sh
```

## Pendências obrigatórias para fechar o ambiente
- criar os scripts restantes de backup
- criar os scripts de restore
- criar os checks locais
- criar as units do `systemd`
- confirmar caminhos reais de arquivos e Qdrant
- confirmar destino remoto do backup
