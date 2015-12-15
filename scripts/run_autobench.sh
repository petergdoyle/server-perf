autobench_load='--low_rate 20 --high_rate 200 --rate_step 20 --num_call 10 --num_conn 5000'
autobench --single_host --host1=engine2 --port1=5040 --uri1="/servlet/perf?size=100000" --low_rate 20 --high_rate 200 --rate_step 20 --num_call 10 --num_conn 5000 --timeout 5  --file engine2_server_perf_tomcat_size_100k.tsv
