
dryrun=''

for param in "$@"
do
    echo "$param"
    if [ $param = "--dry-run" ]; then
      dryrun='--dry-run'
    fi
done

cmd="dosomething ${dryrun}"
echo $cmd
