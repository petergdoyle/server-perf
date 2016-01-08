/*
 */
package com.cleverfishsoftware.services.servlet;

import static com.cleverfishsoftware.services.common.CommonUtils.ONE_KB;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Queue;
import java.util.concurrent.LinkedBlockingQueue;
import javax.servlet.AsyncContext;
import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author peter
 */
public class EchoReadListenerUsingCharArrays implements ReadListener {

    private final AsyncContext context;
    private final ServletInputStream is;
    private final HttpServletResponse res;
    private final Queue queue;

    public EchoReadListenerUsingCharArrays(AsyncContext context, ServletInputStream is, HttpServletResponse res) {
        this.queue = new LinkedBlockingQueue();
        this.context = context;
        this.is = is;
        this.res = res;
    }

    @Override
    public void onDataAvailable() throws IOException {
        StringBuilder sb = new StringBuilder();
        int len = -1;
        byte b[] = new byte[10 * ONE_KB];
        while (is.isReady() && (len = is.read(b)) != -1) {
            String data = new String(b, 0, len);
            sb.append(data);
        }
        queue.add(sb.toString());

//        byte[] buf = new byte[ONE_KB * 10];
//        int len = -1;
//        ByteBuffer bbuffer = ByteBuffer.allocate(buf.length); 
//        while (is.isReady() && (len = is.read(buf)) != -1) {
//            bbuffer.p
//        }
//        queue.add(bbuffer);
    }

    @Override
    public void onAllDataRead() throws IOException {
        ServletOutputStream output = res.getOutputStream();
        WriteListener writeListener = new EchoWriteListener(output, queue, context);
        output.setWriteListener(writeListener);
    }

    @Override
    public void onError(Throwable t) {
        System.err.println(t);
        context.complete();
    }

}
