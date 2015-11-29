/*
 */
package com.cleverfishsoftware.services.common;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

/**
 *
 * @author peter
 */
public class GeneratedContent {

    private static final int ONE_MB = 1024;
    private static final int BUFFER_SIZE = 10 * ONE_MB;
    private static final CharBuffer CHAR_BUFFER = ByteBuffer.allocateDirect(BUFFER_SIZE).asCharBuffer();
    private static final GeneratedContent INSTANCE;

    static {
        INSTANCE = new GeneratedContent();
        boolean on = false;
        while (CHAR_BUFFER.remaining() > 0) {
            if (on) {
                CHAR_BUFFER.put('1');
            } else {
                CHAR_BUFFER.put('0');
            }
            on = !on;
        }
        System.out.println(
                "buffer capacity:  " + CHAR_BUFFER.capacity()
                + "\nbuffer hasRemaining:  " + CHAR_BUFFER.hasRemaining()
                + "\nbuffer length:  " + CHAR_BUFFER.length()
        );
    }

    private GeneratedContent() {
    }

    public static GeneratedContent getInstance() {
        return INSTANCE;
    }

    /**
     * Retrieve a number of bytes
     *
     * @param size the size of the byte array to return
     * @return the number of bytes specified
     */
    public char[] get(int size) {
        char[] data = new char[size];
        CHAR_BUFFER.rewind();
        CHAR_BUFFER.get(data, 0, size);
        return data;
    }

    /**
     * Generate randomly sized byte array
     *
     * @return a random number of bytes
     */
    public char[] any() {
        double pct = Math.random();
        System.out.println("pct: " + pct);
        return get((int) (CHAR_BUFFER.capacity() * pct));
    }

    public static void main(String... args) throws UnsupportedEncodingException {
        GeneratedContent instance = getInstance();

        for (int i = 0; i < 50; i++) {
            char[] content = instance.get(1000);
//            char[] any = instance.any();
            System.out.println(new String(content));
        }
    }

}