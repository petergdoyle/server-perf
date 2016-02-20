/*
 */
package com.cleverfishsoftware.serverperf.undertow;

import io.undertow.Undertow;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.Headers;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author peter
 */
public class UndertowHttpPingServer {

    private static final String USAGE_MSG = "Usage: java "
            + "java -jar target/server-perf-undertow-1.0-SNAPSHOT.jar "
            + "<port>";

    private final static AtomicInteger COUNTER = new AtomicInteger(1);

    public static void main(final String[] args) {
        if (args.length == 0) {
            System.out.println(USAGE_MSG);
            System.exit(1);
        }

        int port = 0;
        try {
            port = Integer.parseInt(args[0]);
        } catch (NumberFormatException ex) {
            System.out.println(USAGE_MSG);
            System.exit(1);
        }
        Undertow server = Undertow.builder()
                .addHttpListener(port, "0.0.0.0")
                .setHandler((final HttpServerExchange exchange) -> {
                    COUNTER.incrementAndGet();
                    exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                    //exchange.getResponseSender().send("Hello World");
                }).build();
        server.start();
    }

}
