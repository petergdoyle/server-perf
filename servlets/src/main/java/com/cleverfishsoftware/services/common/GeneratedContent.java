/*
 */
package com.cleverfishsoftware.services.common;

import static com.cleverfishsoftware.services.common.CommonUtils.getRandomInteger;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.util.Arrays;

/**
 *
 * @author peter
 */
public class GeneratedContent {

    private static final int ONE_KB = 1024;
    private static final int ONE_MB = 1000 * ONE_KB;
    private static final int BUFFER_SIZE = 10 * ONE_MB;
    // note the charbuffer will take two bytes per character so the size should be 5MB 
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

    public final int getMaxLength() {
        return CHAR_BUFFER.capacity();
    }

    /**
     * Retrieve a number of bytes
     *
     * @param size the size of the byte array to return
     * @return the number of bytes specified
     */
    public char[] get(final int size) throws IllegalArgumentException {
        int s = size > CHAR_BUFFER.capacity() ? CHAR_BUFFER.capacity() : size;
        char[] data = new char[s];
        CHAR_BUFFER.rewind();
        CHAR_BUFFER.get(data, 0, s);
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
        int maxLength = instance.getMaxLength();
        System.out.println("content max length: " + maxLength);
        for (int i = 0; i < 5; i++) {
            int pct = getRandomInteger(1, 10) * 10;
            System.out.println("pct: " + pct);
            int size = maxLength * (pct/010);
            char[] content = instance.get(size);
            System.out.println("size: " + size / 1000 + " kb");
            System.out.println(Arrays.toString(content));
        }
    }

}
