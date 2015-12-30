/*
 */
package com.cleverfishsoftware.services.servlet;

import com.cleverfishsoftware.services.common.ContentGeneratorStatic;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import javax.servlet.AsyncContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;

/**
 *
 * @author peter
 */
public class GeneratedContentWriteListenerAndSleep implements WriteListener, Runnable {

    private final ServletOutputStream sos;
    private final ContentGeneratorStatic content;
    private final ByteBuffer buffer;
    private final AsyncContext context;
    private final long sleep;
    private final int size;
    private final ThreadInfo ti;
    private final ScheduledThreadPoolExecutor scheduler;

    public GeneratedContentWriteListenerAndSleep(ServletOutputStream sos, final ContentGeneratorStatic content,
            final int size, final AsyncContext context,
            final long sleep,
            final ScheduledThreadPoolExecutor scheduler,
            final ThreadInfo ti) {
        this.sos = sos;
        this.content = content;
        this.size = size;
        this.context = context;
        this.sleep = sleep;
        this.scheduler = scheduler;
        this.ti = ti;
        buffer = content.getBUFFER().duplicate();
        buffer.rewind();
        buffer.position(size);
        buffer.flip();
    }

    @Override
    public void onWritePossible() throws IOException {
        if (sos.isReady()) {
            if (!buffer.hasRemaining()) {
                context.complete();
                ti.done();
                return;
            }
            while (sos.isReady() && buffer.hasRemaining()) {
                sos.write(buffer.get());
            }
            scheduler.schedule(this, sleep, TimeUnit.MILLISECONDS);
        }
    }

    @Override
    public void onError(Throwable t) {
        System.err.println(t);
        context.complete();
    }

    @Override
    public void run() {
        try {
            onWritePossible();
        } catch (Exception ex) {
            onError(ex);
        }

    }

}
