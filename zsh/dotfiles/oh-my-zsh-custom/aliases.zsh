alias gcp-project="gcloud config set project $GCLOUD_DEFAULT_PROJECT"
alias gcp-account="gcloud config set account $GCLOUD_DEFAULT_ACCOUNT"



dbtr() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --threads 50
}

dbtt() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --threads 50
}

dbtrp() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --target "$GCLOUD_DEFAULT_PROD_PROJECT" --threads 50
}

dbttp() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --target "$GCLOUD_DEFAULT_PROD_PROJECT" --threads 50
}