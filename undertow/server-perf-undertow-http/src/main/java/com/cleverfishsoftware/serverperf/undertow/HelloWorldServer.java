/*
 */
package com.cleverfishsoftware.serverperf.undertow;

import io.undertow.Undertow;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.Headers;

/**
 *
 * @author peter
 */
public class HelloWorldServer {

    public static void main(final String[] args) {
        Undertow server = Undertow.builder()
                .addHttpListener(5090, "localhost")
                .setHandler((final HttpServerExchange exchange) -> {
                    exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                    exchange.getResponseSender().send("Hello World");
        }).build();
        server.start();
    }

}
