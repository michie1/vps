#!/bin/bash

# Kubernetes PVC Backup Script
BACKUP_DIR="/home/m/kubernetes/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting PVC backup to: $BACKUP_DIR"

# Function to backup PVC data
backup_pvc() {
    local pvc_name=$1
    local app_name=$2
    local mount_path=$3
    
    echo "Backing up $pvc_name..."
    
    # Create backup pod without TTY to avoid terminal output
    kubectl run backup-$app_name --rm -i --restart=Never \
        --image=alpine:latest \
        --overrides="{
            \"spec\": {
                \"containers\": [{
                    \"name\": \"backup-$app_name\",
                    \"image\": \"alpine:latest\",
                    \"command\": [\"/bin/sh\", \"-c\", \"tar czf - -C $mount_path . 2>/dev/null\"],
                    \"volumeMounts\": [{
                        \"name\": \"data\",
                        \"mountPath\": \"$mount_path\"
                    }]
                }],
                \"volumes\": [{
                    \"name\": \"data\",
                    \"persistentVolumeClaim\": {
                        \"claimName\": \"$pvc_name\"
                    }
                }]
            }
        }" > "$BACKUP_DIR/${app_name}_data.tar.gz" 2>/dev/null
    
    echo "✓ Backup completed for $pvc_name"
}

# Backup PostgreSQL with pg_dump (including data)
echo "Backing up PostgreSQL outline database..."
kubectl exec postgres-0 -- pg_dump -U michiel --data-only --inserts outline > "$BACKUP_DIR/postgres_outline_data.sql"
kubectl exec postgres-0 -- pg_dump -U michiel outline > "$BACKUP_DIR/postgres_outline_full.sql"
echo "✓ PostgreSQL backup completed"


# Backup PVC data
backup_pvc "grocy-data" "grocy" "/data"
backup_pvc "outline-data" "outline" "/data"
backup_pvc "registry-storage-cr-0" "registry" "/data"

echo "All backups completed in: $BACKUP_DIR"
echo "Backup files:"
ls -lh "$BACKUP_DIR"