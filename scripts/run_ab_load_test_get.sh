

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


ab -n $concurrent_requests -c $users $url
