# server-perf SpringBoot

SpringBoot uses embedded http server. You are able to select between Tomcat and Jetty

"Embedded" means that you program ships with the server within it as opposed to a web application being deployed to external server.

With embedded server your application is packaged with the server of choice and responsible for server start-up and management.

From the user standpoint the difference is:

-Application with embedded server looks like a regular java program. You just launch it and that's it.
-Regular wep application is usually a war archive which needs to be deployed to some server
-Embedding a server is very useful for testing purposes where you can start or stop server at will during the test.
