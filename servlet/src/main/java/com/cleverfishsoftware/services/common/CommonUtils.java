/*
 */
package com.cleverfishsoftware.services.common;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

/**
 *
 * @author peter
 */
public class CommonUtils {

    public static final int ONE_KB = 1024;
    public static final int ONE_MB = 1048576;
    public static final int ONE_GB = 1073741824;

    private static final int STREAM_BUFFER = ONE_KB * 10;
    private static final int COPY_BUFFER = ONE_KB;

    public static long stream(InputStream is, OutputStream os) throws IOException {
        try (
                ReadableByteChannel inputChannel = Channels.newChannel(is);
                WritableByteChannel outputChannel = Channels.newChannel(os);) {
            ByteBuffer buffer = ByteBuffer.allocateDirect(STREAM_BUFFER);
            long size = 0;

            while (inputChannel.read(buffer) != -1) {
                buffer.flip();
                size += outputChannel.write(buffer);
                buffer.clear();
            }

            return size;
        }
    }

    public static void copy(InputStream is, OutputStream os) throws IOException {
        byte[] buf = new byte[COPY_BUFFER];
        int len;
        while ((len = is.read(buf)) > 0) {
            os.write(buf, 0, len);
        }
        os.close();
        is.close();
    }

    public static String readInputStreamAsString(InputStream in) throws IOException {
        BufferedInputStream bis = new BufferedInputStream(in);
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        int result = bis.read();
        while (result != -1) {
            byte b = (byte) result;
            buf.write(b);
            result = bis.read();
        }
        return buf.toString();
    }

    public static boolean isSpecified(String value) {
        return value != null && !value.isEmpty();
    }

    public static boolean isNumeric(String value) {
        return value.matches("\\d+");
    }

    public static int getRandomInteger(int max, int min) {
        return ((int) (Math.random() * (max - min))) + min;
    }

}
