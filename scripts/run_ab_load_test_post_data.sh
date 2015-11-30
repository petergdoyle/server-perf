
while [[ -z "$users" ]]
do
  echo -n "Enter number of users: "
  read users
done
while [[ -z "$concurrent_requests" ]]
do
  echo -n "Enter number of concurrent requests: "
  read concurrent_requests
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

cmd="ab -p $data -n $users -c $concurrent_requests $url"
echo "running... $cmd"
eval $cmd
