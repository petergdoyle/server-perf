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

/**
 *
 * @author peter
 */
public class ContentGeneratorStatic implements ContentGenerator {

    private static final int ONE_KB = 1024;
    private static final int ONE_MB = 1000 * ONE_KB;
    private static final int BUFFER_SIZE = 10 * ONE_MB;
    private static final ByteBuffer BUFFER = ByteBuffer.allocateDirect(BUFFER_SIZE);
    private static final ContentGeneratorStatic INSTANCE;

    static {
        INSTANCE = new ContentGeneratorStatic();
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
//        displayBufferLoadStatistics();

    }

    private static void displayBufferLoadStatistics() {
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

    private ContentGeneratorStatic() {
    }

    public static ContentGeneratorStatic getInstance() {
        return INSTANCE;
    }

    @Override
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
        int safeSize = getSafeSize(size);
        byte[] data = new byte[safeSize];
        ByteBuffer duplicate = BUFFER.duplicate();
        duplicate.rewind();
        duplicate.get(data, 0, safeSize);
        return data;
    }

    public ByteBuffer getBUFFER() {
        return BUFFER;
    }

    @Override
    public void write(OutputStream os, final int size) throws IOException {
        ByteBuffer duplicate = BUFFER.duplicate();
        duplicate.rewind();
        duplicate.position(size);
        duplicate.flip();
        while (duplicate.hasRemaining()) {
            os.write(duplicate.get());
        }
    }

    public void writeChannel(OutputStream os, final int size) throws IOException {
        ByteBuffer duplicate = BUFFER.duplicate();
        duplicate.rewind();
        duplicate.position(size);
        duplicate.flip();
        WritableByteChannel oc = Channels.newChannel(os);
        while (duplicate.hasRemaining()) {
            oc.write(duplicate);
        }
    }

    private int getSafeSize(final int size) {
        int getSafeSize = size > BUFFER.capacity() ? BUFFER.capacity() : size;
        return getSafeSize;
    }

    public static void main(String... args) throws UnsupportedEncodingException, IOException {
        ContentGeneratorStatic instance = getInstance();
        int maxLength = instance.getMaxLength();
        //System.out.println("content max length: " + maxLength);
        for (int i = 0; i < 5; i++) {
            int pct = getRandomInteger(1, 10) * 10;
            //System.out.println("pct: " + pct);
            int size = maxLength * (pct / 010);
            instance.write(System.out, size);
        }
        
    }

}
