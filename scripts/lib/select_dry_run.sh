dryrun=$1

for param in "$@"
do
    if [ $param = "--dry-run" ]; then
      dryrun='--dry-run'
    fi
done


