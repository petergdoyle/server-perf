#Java Async and Non-Blocking IO Notes

###Servlet Containers

**Traditional HTTP Server approach: Thread per Request** 
- Web server accepts a request from a client over HTTP
- it creates a thread that handles this and only this connection over its complete lifetime. 
- Threads are usually reused through a thread pool mechanism to avoid the overhead of creating new threads for every request
- Thread take up a approximate a 1Mb of memory, so it could be wise to limit the number of threads kept in the thread pool. However, the drawback of any limitation in the number of threads might be that new incoming connections from clients are rejected since there is no thread free to process the request. 

**HTTP 1.1** 
- possible to keep connections alive between requests
- improves latency but prevents the Thread Per Request model from scaling
- Java NIO (non-blocking io facilities) eliminated the need to keep the thread assigned to the connection when there is no request
- Tomcat and Jetty take this approach today 

**Java Servlet 3.0 introduced the concept of asynchronous processing** already some years ago.
- a request thread is only responsible to accept the request and put it into a processing queue. The Java method that handles the request terminates almost immediately.

**java.util.concurrent.Future `<T>`** interface
- Future.get() is the most important method. It blocks and waits until promised result is available (resolved).
- There is an overloaded version that accepts timeout so you won't wait forever if something goes wild. TimeoutException is thrown if waiting for too long.
-  In the old days you would start a new Thread and somehow wait for results (shared memory, locks, dreadful wait()/notify() pair, etc.)
-  introduced the notion of n ExecutorService to control the thread lifecycle 

**java.util.concurrent.CompletableFuture`<T>`** interface
CompletableFuture class added in Java 8 gives you new ways to handle the completion of asynchronous processing, including nonblocking ways to compose and combine events. 
- java.util.concurrent.Future class provides a simple way to handle the expected completion of an event, but only by means of either polling or waiting for completion. The java.util.concurrent.CompletableFuture class added in Java 8 extends this capability with a range of methods for composing or handling events. 
- CompletableFuture gives you standard techniques for executing application code when an event completes, including various ways to combine tasks (as represented by futures). 
- This combination technique makes it easy (or at least easier than in the past) to write nonblocking code for handling events. 
- possible to use CompletableFuture for both blocking and nonblocking event handling.
- the nonblocking approach requires additional effot

HTTP 1.1 made it possible to keep connections alive between requests. 