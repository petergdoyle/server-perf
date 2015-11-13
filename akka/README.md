# server-perf Akka HTTP

Akka HTTP
The purpose of the Akka HTTP layer is to expose Actors to the web via HTTP and to enable them to consume HTTP services as a client. It is not an HTTP framework, it is an Actor-based toolkit for interacting with web services and clients. This toolkit is structured into several layers:

akka-http-core: A complete implementation of the HTTP standard, both as client and server.
akka-http: A convenient and powerful routing DSL for expressing web services.
akka-http-testkit: A test harness and set of utilities for verifying your web service implementations.


Akka HTTP microservice
Simple (micro)service which demonstrates how to accomplish tasks typical for REST service using Akka HTTP. Project includes: starting standalone HTTP server, handling simple file-based configuration, logging, routing, deconstructing requests, unmarshalling JSON entities to Scala's case classes, marshaling Scala's case classes to JSON responses, error handling, issuing requests to external services, testing with mocking of external services.

based on http://www.typesafe.com/activator/template/akka-http-microservice
