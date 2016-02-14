/*
 */
package com.cleverfishsoftware.services.servlet;

import java.io.IOException;
import java.util.Queue;
import javax.servlet.AsyncContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;

/**
 *
 * @author peter
 */
public class EchoWriteListener implements WriteListener {

    private final ServletOutputStream sos;
    private final Queue queue;
    private final AsyncContext context;

    public EchoWriteListener(ServletOutputStream sos, Queue queue, AsyncContext context) {
        this.sos = sos;
        this.queue = queue;
        this.context = context;
    }

    @Override
    public void onWritePossible() throws IOException {
        while (queue.peek() != null && sos.isReady()) {
            String data = (String) queue.poll();
            sos.print(data);
        }
        if (queue.peek() == null) {
            context.complete();
        }
    }

    @Override
    public void onError(Throwable t) {
        System.err.println(t);
        context.complete();
    }

}
