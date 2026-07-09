#!/bin/bash
USER_HOME="/home/$USER"
BACKUP_DIR="$USER_HOME/backups"
DATA_DIR="$USER_HOME/data"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="${BACKUP_DIR}/backup${DATE}.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

log() {
    echo "$(date '+%F %X') - $1" | tee -a "$LOG_FILE"
}

if [[ ! -d "$DATA_DIR" ]]; then
	echo "Ошибка: папка $DATA_DIR не существует"
    	exit 1
fi

mkdir -p "$BACKUP_DIR"

log "Начинаем созданием бэкапа..."
if tar -czf "$ARCHIVE_NAME" -C "$DATA_DIR" .; then
	ARCHIVE_SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)
	log "Архив создан: $ARCHIVE_NAME (размер: $ARCHIVE_SIZE)"
else
    	log "ОШИБКА: не удалось создать архив"
    	exit 1
fi

log "Поиск архивов старше 7 дней..."
DELETED=$(find "$BACKUP_DIR" -name "backup*.tar.gz" -mtime +7 -delete -print)

if [[ -n "$DELETED" ]]; then
	log "Удалены старые архивы: $DELETED"
else
    	log "Старых архивов не найдено"
fi

log "Бэкап завершен успешно!"

