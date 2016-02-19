/*
 */
package com.cleverfishsoftware.serverperf.undertow;

import io.undertow.Undertow;
import io.undertow.io.Sender;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.Headers;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author peter
 */
public class UndertowHttpServer {

    private static final String USAGE_MSG = "Usage: java "
            + "java -jar target/server-perf-undertow-1.0-SNAPSHOT.jar "
            + "<port>";

    private final static AtomicInteger COUNTER = new AtomicInteger(1);

    private final int port;

    private Undertow server;

    public UndertowHttpServer(int port) {
        this.port = port;
    }

    public void start() {
        server = Undertow.builder()
                .addHttpListener(port, "0.0.0.0")
                .setHandler((final HttpServerExchange exchange) -> {
                    exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                    Sender sender = exchange.getResponseSender();
                    String msg
                            = "Undertow: \n" + UndertowHttpServer.class.getName()
                            + "\nRequests Processed: " + COUNTER.getAndIncrement()
                            + "\nMsg: server is running";
                    sender.send(msg);
                }).build();
    }

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

        UndertowHttpServer server = new UndertowHttpServer(port);
        server.start();
        System.err.println("Undertow HTTP Server listening on ://0.0.0.0:" + port + '/');
    }

}
