

for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf/async?sleep=500" & done; wait
for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf?sleep=500" & done; wait

for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf/async?size=500" & done; wait
for i in {1..50}; do curl -i -X GET "http://localhost:5040/servlet/perf?size=500" & done; wait
