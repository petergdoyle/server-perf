/*
 */
package com.cleverfishsoftware.services.common;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 *
 * @author peter
 */
public class CommonUtils {

    public static void copy(InputStream in, OutputStream out) throws IOException {
        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0) {
            out.write(buf, 0, len);
        }
        out.close();
        in.close();
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
