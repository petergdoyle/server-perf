
while [[ -z "$users" ]]
do
  echo -n "Enter number of users: "
  read users
done
while [[ -z "$repetitions" ]]
do
  echo -n "Enter number of repetitions "
  read repetitions
done
while [[ -z "$url" ]]
do
  echo -n "Enter the url: "
  read url
done
while [[ -z "$data" && ! -f "$data" ]]
do
  echo -n "Enter the data file (absolute or relative path): "
  read data
  if [ ! -f "$data" ]
    then
    echo "Could not open POST data file: No such file or directory"
  fi
done

end_part="\"$url POST >$data\""
cmd="siege -q --concurrent=$users --reps=$repetitions $end_part"
echo "running... $cmd"
eval $cmd
