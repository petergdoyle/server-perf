# server-perf [DRAFT 0.0.1]

A project to setup and compare the performance characteristics of a variety of HTTP accessible servers

![scope](https://raw.githubusercontent.com/petergdoyle/server-perf/master/img/server-perf-service-map.png)

**Motivation**

Understanding the performance characteristics of your application is more important these days than ever. There are many factors that affect performance and scalability most notably how well the application itself is designed and coded. But it would be interesting to compare the performance characteristics and ceilings of various servers to understand those characteristics better and make accomodations to the solution design to leverage those features or be wary of their limitations. There are a number of runtime environmental factors to consider as well the rapid movement away from monolitic vm based application servers and vms and a rapid movement towards containerization and ephemeral microservices it is important then to consider the costs and benefits in terms of performance in this area as well. 

![performance](https://raw.githubusercontent.com/petergdoyle/server-perf/master/img/server-perf-performance.png)

**Scope**

- For this effort, a variety of servers (and classifictions of servers), benchmark tools, usage patterns were selected that should be accesible (as in available through the public domain) and easily understood and reproduceable (in the case of the patterns) and elemental. These choices are not arbitrary but are somewhat limited. Future work might take the basics covered here and extend them out. 
- These tests are not necessarily reflective of "real-life" usage and attempt to consider high-volume homogenous processing scenarion NOT like those found in most real situations.
- While high-performance of any software is based on tuning, the intent is to not spend too much effort to tune the servers. They are to be compared "out of the box" for this effort 
- The scope of the effort then should be to answer the questions "Given this usage-pattern, how does this server compare to the others"
	- How does envrionmental differences affect performance? ie. Containers, versus Virtual Machines, versus host 
	- Do the tools used to generate load return consistent results?
	- What does the resource load on the server and the client look like?
 


**Assumptions**

- HTTP 1.1 amongst other things intoduced the keep-alive feature to reuse connections and thereby cut down on costly request-per-connection approaches but HTTP 1.1 still is fundamentally a synchronous communication model whereby a single connection can handle many request-response interactions in full-duplex mode over TCP packet-switched networks, the clients must send a request and wait for a response. HTTP 2.0 brings in features like message-pipelining, so that should incrase performance quite a bit.
- Asynchronous IO and Asynchronous executions allow servers/services to scale beyond their syncrhonous counterparts but this comes at the cost of increased complexity and pure speed where in many scenarios the benefits may not outweigh the costs. 
- Increased developer productivity and consistency and reusability by employing frameworks on top of HTTP servers comes at some measureable cost to performance. 
- Typical monolitic services and web sites usually interact with many backend system interfaces and services that introduce latency. Increased latency means servers will have to manage resources to keep a handle on those long running interactions on the backend while still maintaining the ability to allow more connections on the frontend. So the higher load put on a server, the more scalable it must be in order remain responsive. 
- When building an internet facing service or website, a software engineer must make a number of choices with regards to use of datastructures and the algorithms that act upon them. The choices made here are critical to speed and scale of the running application.
- to be completed`...`

**Approach**
The approach here will be fairly straightforward. To compare benchmark results of different services with different client tools in different server environments based on a set of defined service patterns. This matrix of options should be able to demonstrate the differences or consistencies between the Service Patterns, the Servers, the Client tools, and the different environment options to run both the Client tools and the Servers.
![protocol](https://raw.githubusercontent.com/petergdoyle/server-perf/master/img/server-perf-protocol.png)

**Environment**  

**Measurements**
It is important to measure both the client and the server to approach understanding the results of load tests and benchmarks. Different service patterns should stress different client/server architectures differently. There are a number of available tools to measure both the OS and managed-runtime based servers like those that run on V8 or a JVM.

![protocol](https://raw.githubusercontent.com/petergdoyle/server-perf/master/img/server-perf-measurements.png)

**Patterns**

**Results**

**Observations**

**Conclusions**


## Installation

**Running Docker Containers**

**Running on Virtual Machines**

**Running on Host machines (no containerization or virtualization**






**Tool Notes**

JMeter - navigate into the jmeter folder, and run the jmeter_install.sh script. If you are on another platform, follow these instructions for installing and running JMeter http://www.oodlestechnologies.com/blogs/Installation-and-configuration-for-Apache-Jmeter
A nice intro to using JMeter https://www.digitalocean.com/community/tutorials/how-to-use-apache-jmeter-to-perform-load-testing-on-a-web-server

## Usage

TODO: Write usage instructions
