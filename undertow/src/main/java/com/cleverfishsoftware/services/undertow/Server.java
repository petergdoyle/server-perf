/*
 */
package com.cleverfishsoftware.services.undertow;

import io.undertow.Undertow;
import io.undertow.io.Sender;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.Headers;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author peter
 */
public class Server {

    private final static AtomicInteger COUNTER = new AtomicInteger(1);

    public static void main(final String[] args) {
        Undertow server = Undertow.builder()
                .addHttpListener(5090, "0.0.0.0")
                .setHandler((final HttpServerExchange exchange) -> {
                    exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                    Sender sender = exchange.getResponseSender();
                    String msg
                            = "Undertow: \n" + Server.class.getName()
                            + "\nRequests Processed: " + COUNTER.getAndIncrement()
                            + "\nMsg: server is running";
                    sender.send(msg);
                }).build();
        server.start();
    }

}
