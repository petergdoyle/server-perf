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

    public static long stream(InputStream is, OutputStream os) throws IOException {
        ReadableByteChannel inputChannel = Channels.newChannel(is);
        WritableByteChannel outputChannel = Channels.newChannel(os);
        ByteBuffer buffer = ByteBuffer.allocateDirect(ONE_KB * 10);
        long size = 0;
        while (inputChannel.read(buffer) != -1) {
            buffer.flip();
            size += outputChannel.write(buffer);
            buffer.clear();
        }
        os.close();
        is.close();
        return size;
    }

    public static long copy(InputStream is, OutputStream os) throws IOException {
        byte[] buf = new byte[ONE_KB * 10];
        int len;
        long size = 0;
        while ((len = is.read(buf)) != -1) {
            os.write(buf, 0, len);
            size += len;
        }
        os.close();
        is.close();
        return size;
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
