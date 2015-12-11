/*
 */
package com.cleverfishsoftware.services.servlet;

import com.cleverfishsoftware.services.common.GeneratedContent;
import java.io.IOException;
import java.nio.ByteBuffer;
import javax.servlet.AsyncContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;

/**
 *
 * @author peter
 */
public class GeneratedContentWriteListener implements WriteListener {

    private final ServletOutputStream sos;
    private final GeneratedContent content;
    private final ByteBuffer buffer;
    private final AsyncContext context;
    private final long sleep;
    private final int size;

    public GeneratedContentWriteListener(ServletOutputStream sos, GeneratedContent content, final int size, AsyncContext context, long sleep) {
        this.sos = sos;
        this.content = content;
        this.size = size;
        this.context = context;
        this.sleep = sleep;
        buffer = content.getBUFFER().duplicate();
        buffer.rewind();
        buffer.position(size);
        buffer.flip();
    }

    @Override
    public void onWritePossible() throws IOException {
        while (sos.isReady() && buffer.hasRemaining()) {
            sos.write(buffer.get());
        }
        
        if (!buffer.hasRemaining()) {
            context.complete();
        }
    }

    @Override
    public void onError(Throwable t) {
        System.err.println(t);
        context.complete();
    }

}
