###Siege Output

**Transactions** The number of server hits. In the example, 25 simulated users [ -c25 ] each hit the server 10 times [ -r10 ], a total of 250 transactions. It is possible for the number of transactions to exceed the number of hits that were scheduled. Siege counts every server hit a transaction, which means redirections and authentication challenges count as two hits, not one. With this regard, siege follows the HTTP specification and it mimics browser behavior.

**Availability** This is the percentage of socket connections successfully handled by the server. It is the result of socket failures (including timeouts) divided by the sum of all connection attempts. This number does not include 400 and 500 level server errors which are recorded in “Failed transactions” described below.

**Elapsed time** The duration of the entire siege test. This is measured from the time the user invokes siege until the last simulated user completes its transactions. Shown above, the test took 14.67 seconds to complete.

**Data transferred** The sum of data transferred to every siege simulated user. It includes the header information as well as content. Because it includes header information, the number reported by siege will be larger then the number reported by the server. In internet mode, which hits random URLs in a configuration file, this number is expected to vary from run to run.

**Response time** The average time it took to respond to each simulated user’s requests.

**Transaction rate** The average number of transactions the server was able to handle per second, in a nutshell: transactions divided by elapsed time.

**Throughput** The average number of bytes transferred every second from the server to all the simulated users.

**Concurrency** The average number of simultaneous connections, a number which rises as server performance decreases.

**Successful transactions** The number of times the server responded with a return code < 400.

**Failed transactions** The number of times the server responded with a return code >= 400 plus the sum of all failed socket transactions which includes socket timeouts.

**Longest transaction** The greatest amount of time that any single transaction took, out of all transactions.

**Shortest transaction** The smallest amount of time that any single transaction took, out of all transactions.