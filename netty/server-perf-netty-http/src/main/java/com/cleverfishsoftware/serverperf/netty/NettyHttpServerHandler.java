/*
 */
package com.cleverfishsoftware.serverperf.netty;

import com.cleverfishsoftware.services.common.ContentGeneratorStatic;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.DecoderResult;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.DefaultHttpResponse;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpUtil;
import io.netty.handler.codec.http.HttpHeaderValues;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpObject;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpResponse;
import io.netty.handler.codec.http.LastHttpContent;
import io.netty.handler.codec.http.QueryStringDecoder;
import io.netty.handler.codec.http.cookie.Cookie;
import io.netty.handler.codec.http.cookie.ServerCookieDecoder;
import io.netty.handler.codec.http.cookie.ServerCookieEncoder;
import io.netty.util.CharsetUtil;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import static io.netty.handler.codec.http.HttpResponseStatus.*;
import static io.netty.handler.codec.http.HttpVersion.*;
import io.netty.util.AsciiString;
import java.io.File;
import java.util.concurrent.atomic.AtomicInteger;
import javax.activation.MimetypesFileTypeMap;

public class NettyHttpServerHandler extends SimpleChannelInboundHandler<Object> {

    private static final AsciiString CONTENT_TYPE = new AsciiString("Content-Type");
    private static final AsciiString CONTENT_LENGTH = new AsciiString("Content-Length");
    private static final AsciiString CONNECTION = new AsciiString("Connection");
    private static final AsciiString KEEP_ALIVE = new AsciiString("keep-alive");
    private static final AtomicInteger COUNTER = new AtomicInteger(0);
    private HttpRequest request;
    private final static ContentGeneratorStatic CONTENT = ContentGeneratorStatic.getInstance();
    /**
     * Buffer that stores the response content
     */
    private final StringBuilder buf = new StringBuilder();

    private String path;
    private int size_param = 0;
    private int sleep_param = 0;

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush();
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, Object msg) {
        if (msg instanceof HttpRequest) {

            HttpRequest httpRequest = this.request = (HttpRequest) msg;
            buf.setLength(0);

            if (HttpUtil.is100ContinueExpected(httpRequest)) {
                send100Continue(ctx);
            }

            QueryStringDecoder queryStringDecoder = new QueryStringDecoder(httpRequest.uri());
            path = queryStringDecoder.path();
            Map<String, List<String>> params = queryStringDecoder.parameters();

            COUNTER.incrementAndGet();

            if (path.contains("/echo")) {
                HttpHeaders headers = httpRequest.headers();
                echoHeaders(headers);
                echoRequestParams(params);
            } else if (path.contains("/latency")) {
                sendLatentResponse(params, httpRequest);
            } else if (path.contains("/info")) {
                sendServerInfoResponse(path, httpRequest);
            } else if (path.contains("/upload")) {
                // not implemented
            } else if (path.contains("/download")) {
                sendGeneratedResponse(ctx, params, httpRequest);
            }

        }

        if (msg instanceof HttpContent) {

            if (path.contains("/echo")) {
                HttpContent httpContent = (HttpContent) msg;
                ByteBuf content = httpContent.content();
                if (content.isReadable()) {
                    buf.append(content.toString(CharsetUtil.UTF_8));
                    appendDecoderResult(buf, request);
                }
            } else if (path.contains("/info")) {

            } else if (path.contains("/upload")) {

            } else if (path.contains("/download")) {

            }

            if (msg instanceof LastHttpContent) {
                LastHttpContent trailer = (LastHttpContent) msg;
                if (!writeResponse(trailer, ctx)) {
                    // If keep-alive is off, close the connection once the content is fully written.
                    ctx.writeAndFlush(Unpooled.EMPTY_BUFFER).addListener(ChannelFutureListener.CLOSE);
                }
            }

        }
    }

    private void sendLatentResponse(Map<String, List<String>> params, HttpRequest httpRequest) {
        if (params.containsKey("sleep")) {
            List<String> vals = params.get("sleep");
            String sizeValue = vals.get(0);
            sleep_param = Integer.parseInt(sizeValue);
        }
        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, OK);
        HttpUtil.setContentLength(response, 0);
        response.headers().set(HttpHeaderNames.CONTENT_TYPE, "text/plain; charset=UTF-8");
        if (HttpUtil.isKeepAlive(httpRequest)) {
            response.headers().set(HttpHeaderNames.CONNECTION, HttpHeaderValues.KEEP_ALIVE);
        }
        buf.append("");
        appendDecoderResult(buf, httpRequest);
    }

    private void sendGeneratedResponse(ChannelHandlerContext ctx, Map<String, List<String>> params, HttpRequest httpRequest) {
        
        if (params.containsKey("size")) {
            List<String> vals = params.get("size");
            String sizeValue = vals.get(0);
            size_param = Integer.parseInt(sizeValue);
        }

        boolean keepAlive = HttpUtil.isKeepAlive(httpRequest);
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, OK, Unpooled.wrappedBuffer(CONTENT.get(size_param)));
        HttpUtil.setContentLength(response, size_param);
        response.headers().set(HttpHeaderNames.CONTENT_TYPE, "text/plain; charset=UTF-8");

        if (!keepAlive) {
            ctx.write(response).addListener(ChannelFutureListener.CLOSE);
        } else {
            response.headers().set(CONNECTION, KEEP_ALIVE);
            ctx.write(response);
        }
    }

    private void sendServerInfoResponse(String path, HttpRequest httpRequest) {
        buf.append("Server: Netty HTTP Server").append("\r\n");
        buf.append("Path: ").append(path).append("\r\n");
        buf.append("Requests Processed: ").append(COUNTER.get()).append("\r\n");
        buf.append("Msg: server is running").append("\r\n");
        buf.append("VERSION: ").append(httpRequest.protocolVersion()).append("\r\n");
        buf.append("HOSTNAME: ").append(httpRequest.headers().get(HttpHeaderNames.HOST, "unknown")).append("\r\n");
        buf.append("REQUEST_URI: ").append(httpRequest.uri()).append("\r\n\r\n");
        appendDecoderResult(buf, httpRequest);
    }

    private void echoRequestParams(Map<String, List<String>> params) {
        if (!params.isEmpty()) {
            for (Entry<String, List<String>> p : params.entrySet()) {
                String key = p.getKey();
                List<String> vals = p.getValue();
                for (String val : vals) {
                    buf.append("PARAM: ").append(key).append(" = ").append(val).append("\r\n");
                }
            }
            buf.append("\r\n");
        }
    }

    private void echoHeaders(HttpHeaders headers) {
        if (!headers.isEmpty()) {
            for (Map.Entry<String, String> h : headers) {
                CharSequence key = h.getKey();
                CharSequence value = h.getValue();
                buf.append("HEADER: ").append(key).append(" = ").append(value).append("\r\n");
            }
            buf.append("\r\n");
        }
    }

    private static void appendDecoderResult(StringBuilder buf, HttpObject o) {
        DecoderResult result = o.decoderResult();
        if (result.isSuccess()) {
            return;
        }

        buf.append(".. WITH DECODER FAILURE: ");
        buf.append(result.cause());
        buf.append("\r\n");
    }

    private boolean writeResponse(HttpObject currentObj, ChannelHandlerContext ctx) {
        // Decide whether to close the connection or not.
        boolean keepAlive = HttpUtil.isKeepAlive(request);
        // Build the response object.
        FullHttpResponse response = new DefaultFullHttpResponse(
                HTTP_1_1, currentObj.decoderResult().isSuccess() ? OK : BAD_REQUEST,
                Unpooled.copiedBuffer(buf.toString(), CharsetUtil.UTF_8));

        response.headers().set(HttpHeaderNames.CONTENT_TYPE, "text/plain; charset=UTF-8");

        if (keepAlive) {
            // Add 'Content-Length' header only for a keep-alive connection.
            response.headers().setInt(HttpHeaderNames.CONTENT_LENGTH, response.content().readableBytes());
            // Add keep alive header as per:
            // - http://www.w3.org/Protocols/HTTP/1.1/draft-ietf-http-v11-spec-01.html#Connection
            response.headers().set(HttpHeaderNames.CONNECTION, HttpHeaderValues.KEEP_ALIVE);
        }

        // Write the response.
        ctx.write(response);

        return keepAlive;
    }

    private static void send100Continue(ChannelHandlerContext ctx) {
        FullHttpResponse response = new DefaultFullHttpResponse(HTTP_1_1, CONTINUE);
        ctx.write(response);
    }

    MimetypesFileTypeMap mimeTypesMap = new MimetypesFileTypeMap();

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
        ctx.close();
    }
}
