/*
 */
package com.cleverfishsoftware.services.common;

import static com.cleverfishsoftware.services.common.CommonUtils.ONE_MB;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

/**
 *
 * @author peter
 */
public class CharacterGenerator {

    private final ByteBuffer bbuffer = ByteBuffer.allocate(ONE_MB * 5);

    private static final CharacterGenerator instance;

    static {
        instance = new CharacterGenerator();
    }

    private CharacterGenerator() {

        char white_smiley = '\u263A';
        char black_smiley = '\u263B';

        int charCount = 0;
        while (bbuffer.hasRemaining()) {
            if (charCount % 2 == 0) {
                bbuffer.putChar(black_smiley);
            } else {
                bbuffer.putChar(white_smiley);
            }
            charCount++;
        }
        //System.out.println(charCount + " characters loaded");

    }

    public static CharacterGenerator getInstance() {
        return instance;
    }

    public ByteBuffer get(final int sizeInBytes) {
        int count = 0;
        CharBuffer charBuffer = getCharBuffer();
        ByteBuffer newBuffer = ByteBuffer.allocate(sizeInBytes * 2); //these characters will take 2 bytes (not a great idea to assume that) 
        while (charBuffer.hasRemaining() && count < sizeInBytes) {
            newBuffer.putChar(charBuffer.get());
            count++;
        }
        return newBuffer;
    }

    public void print(PrintStream out, final int sizeInBytes) {
        int s = validSize(sizeInBytes);
        CharBuffer charBuffer = getCharBuffer();
        int count = 0;
        while (charBuffer.hasRemaining() && count < s) {
            char c = charBuffer.get();
            out.print(c);
            count += 2;
        }
    }

    public static void main(String... args) throws IOException {

        CharacterGenerator generator = CharacterGenerator.getInstance();

        generator.print(System.out, 5000);
        //System.out.println();

        //System.out.println("--------------");
        generator.print(System.out, 5000);
        //System.out.println();
        
        
        ByteBuffer duplicate = generator.bbuffer.duplicate();
        duplicate.rewind();
        duplicate.position(50); 
        duplicate.flip();
        CharBuffer cbuffer = duplicate.asCharBuffer();
        while (cbuffer.hasRemaining()) {
            //System.out.println(cbuffer.get());
        }
    }


    private int validSize(final int size) {
        int s = 0;
        if (size > bbuffer.capacity()) { // cannot exceed the capacity
            //System.out.println("size > bbuffer.capacity");
            s = bbuffer.capacity();
        } else {
            s = size;
        }
        if (s % 2 != 0) { //number has to be a multiple of 2 since there are 2 bytes per character
            //System.out.println("s % 2 != 0");
            s--;
        }
        if (size < 0) { // must be a positive number 
            //System.out.println("size < 0");
            s = 0;
        }
        return s;
    }

    private CharBuffer getCharBuffer() {
        ByteBuffer duplicate = getByteBuffer();
        duplicate.rewind();
        return duplicate.asCharBuffer();
    }

    private ByteBuffer getByteBuffer() {
        ByteBuffer duplicate = bbuffer.duplicate();
        duplicate.rewind();
        return duplicate;
    }

}
