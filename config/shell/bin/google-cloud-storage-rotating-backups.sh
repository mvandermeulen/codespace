#!/bin/sh

set -e

if test -z "$GOOGLE_CLOUD_STORAGE_BUCKET_URI"; then >&2 echo "GOOGLE_CLOUD_STORAGE_BUCKET_URI not specified, exiting"; exit 1; fi

# In some environments, such as a local development container, it might be necessary to provide the Application Default
# Credentials via the GOOGLE_APPLICATION_CREDENTIALS environment variable.
# The gcloud CLI won't authorize requests using the GOOGLE_APPLICATION_CREDENTIALS environment variable, however it can
# use them to generate an access token. The access token can authorize the gcloud CLI through the
# CLOUDSDK_AUTH_ACCESS_TOKEN environment variable.
CLOUDSDK_AUTH_ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

BACKUP_FILE_NAME=backup-$(date --utc --iso-8601=seconds | rev | cut -c 7- | rev | sed 's/$/Z/' | sed 's/./-/14' | sed 's/./-/17').gz
BACKUP_FILE_PATH=/tmp/$BACKUP_FILE_NAME

echo "some_data" | gzip --stdout --best > $BACKUP_FILE_PATH

echo "Copying $BACKUP_FILE_PATH to $GOOGLE_CLOUD_STORAGE_BUCKET_URI/daily-$BACKUP_FILE_NAME..."
gcloud storage cp $BACKUP_FILE_PATH $GOOGLE_CLOUD_STORAGE_BUCKET_URI/daily-$BACKUP_FILE_NAME
echo "Copied $BACKUP_FILE_PATH to $GOOGLE_CLOUD_STORAGE_BUCKET_URI/daily-$BACKUP_FILE_NAME."

if test "$(date --utc +%d)" -eq "01"; then
  echo "Copying $BACKUP_FILE_PATH to $GOOGLE_CLOUD_STORAGE_BUCKET_URI/monthly-$BACKUP_FILE_NAME..."
  gcloud storage cp $BACKUP_FILE_PATH $GOOGLE_CLOUD_STORAGE_BUCKET_URI/monthly-$BACKUP_FILE_NAME
  echo "Copied $BACKUP_FILE_PATH to $GOOGLE_CLOUD_STORAGE_BUCKET_URI/monthly-$BACKUP_FILE_NAME."
fi

# Rotate (remove) daily backups older than 7776000s (90d).
echo "Rotating old backups..."
gcloud storage ls $GOOGLE_CLOUD_STORAGE_BUCKET_URI \
  | grep --extended-regexp '.*daily-backup-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}Z\.gz$' \
  | { while read line; do echo $line | sed --regexp-extended 's/.*([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}Z)\.gz$/\1/' | sed 's/./:/14' | sed 's/./:/17' | date --utc --file=- +%s | xargs expr $(date --utc +%s) - | xargs test 7776000 -lt && echo $line; done; exit 0; } \
  | gcloud storage rm --read-paths-from-stdin
echo "Rotated old backups."