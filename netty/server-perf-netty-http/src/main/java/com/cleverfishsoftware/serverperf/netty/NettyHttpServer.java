/*
 */
package com.cleverfishsoftware.serverperf.netty;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.Channel;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;

/**
 * An HTTP server that sends back the content of the received HTTP request
 */
public final class NettyHttpServer {

    private static final String USAGE_MSG = "Usage: java "
            + "-cp .:target/lib:target/netty-http1-1.0-SNAPSHOT.jar "
            + NettyHttpServer.class.getName()
            + " <port>";
    private final int port;

    public NettyHttpServer(int port) {
        this.port = port;
    }

    public void start() throws InterruptedException {

        // Configure the server.
        EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    //.handler(new LoggingHandler(LogLevel.INFO))
                    .childHandler(new NettyHttpServerInitializer());

            Channel ch = b.bind(port).sync().channel();
            System.err.println("Netty HTTP Server listening on ://0.0.0.0:" + port + '/');
            ch.closeFuture().sync();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }

    public static void main(String[] args) throws Exception {

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

        NettyHttpServer server = new NettyHttpServer(port);
        server.start();

    }
}
