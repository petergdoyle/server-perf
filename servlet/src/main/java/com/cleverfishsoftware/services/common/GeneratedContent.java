/*
 */
package com.cleverfishsoftware.services.common;

import static com.cleverfishsoftware.services.common.CommonUtils.getRandomInteger;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.WritableByteChannel;
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
//    private static final CharBuffer BUFFER = ByteBuffer.allocateDirect(BUFFER_SIZE).asCharBuffer();
    private static final ByteBuffer BUFFER = ByteBuffer.allocateDirect(BUFFER_SIZE);
    private static final GeneratedContent INSTANCE;

    static {
        INSTANCE = new GeneratedContent();
        boolean on = false;
        byte[] one = "1".getBytes();
        byte[] zero = "0".getBytes();

        while (BUFFER.hasRemaining()) {
            if (on) {
                BUFFER.put(one);
            } else {
                BUFFER.put(zero);
            }
            on = !on;
        }
        System.out.println("BUFFER after loading: position = " + BUFFER.position()
                + "\tLimit = " + BUFFER.limit() + "\tcapacity = "
                + BUFFER.capacity());
        BUFFER.rewind();
        ByteBuffer duplicate = BUFFER.duplicate();
        System.out.println("slice after slicing: position = " + duplicate.position()
                + "\tLimit = " + duplicate.limit() + "\tcapacity = "
                + duplicate.capacity());
        duplicate.rewind();
        System.out.println("BUFFER after rewind: position = " + BUFFER.position()
                + "\tLimit = " + BUFFER.limit() + "\tcapacity = "
                + BUFFER.capacity());
        System.out.println("slice after slicing: position = " + duplicate.position()
                + "\tLimit = " + duplicate.limit() + "\tcapacity = "
                + duplicate.capacity());

    }

    private GeneratedContent() {
    }

    public static GeneratedContent getInstance() {
        return INSTANCE;
    }

    public final int getMaxLength() {
        return BUFFER.capacity();
    }

    /**
     * Retrieve a number of bytes
     *
     * @param size the size of the byte array to return
     * @return the number of bytes specified
     */
    public byte[] get(final int size) throws IllegalArgumentException {
        int s = size > BUFFER.capacity() ? BUFFER.capacity() : size;
        byte[] data = new byte[s];
        ByteBuffer duplicate = BUFFER.duplicate();
        duplicate.rewind();
        duplicate.get(data, 0, s);
        return data;
    }

    public ByteBuffer getAsBuffer(final int size) {
        ByteBuffer buffer = ByteBuffer.allocate(size); 
        buffer.put(get(size)); 
        return buffer;
    }

    public static void main(String... args) throws UnsupportedEncodingException, IOException {
        GeneratedContent instance = getInstance();
        int maxLength = instance.getMaxLength();
        System.out.println("content max length: " + maxLength);
        for (int i = 0; i < 5; i++) {
            int pct = getRandomInteger(1, 10) * 10;
            System.out.println("pct: " + pct);
            int size = maxLength * (pct / 010);
            byte[] content = instance.get(size);
            System.out.println("size: " + size / 1000 + " kb");
//            System.out.println(Arrays.toString(content));
        }

//        instance.stream(System.out, 10);
    }

}
