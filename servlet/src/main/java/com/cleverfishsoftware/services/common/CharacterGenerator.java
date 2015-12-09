/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cleverfishsoftware.services.common;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

/**
 *
 * @author peter
 */
public class CharacterGenerator {

    public static void main(String... args) throws IOException {
        char white_smiley = '\u263A';
        char black_smiley = '\u263B';

        ByteBuffer BUFFER = ByteBuffer.allocateDirect(1024);
        int charCount = 0;
        while (BUFFER.hasRemaining()) {
            if (charCount % 2 == 0) {
                BUFFER.putChar(black_smiley);
            } else {
                BUFFER.putChar(white_smiley);
            }
            charCount++;
        }
        System.out.println(charCount + " characters loaded");
        System.out.println("BUFFER after loading: position = " + BUFFER.position()
                + "\tLimit = " + BUFFER.limit() + "\tcapacity = "
                + BUFFER.capacity());
        BUFFER.rewind();
        System.out.println("BUFFER after rewind: position = " + BUFFER.position()
                + "\tLimit = " + BUFFER.limit() + "\tcapacity = "
                + BUFFER.capacity());

        char[] chars = new char[BUFFER.capacity()];
        CharBuffer asCharBuffer = BUFFER.asCharBuffer();
        charCount = 0;
        while (asCharBuffer.hasRemaining()) {
            System.out.println(asCharBuffer.get());
            charCount++;
        }
        System.out.println(charCount + " characters printed");
        System.out.println("BUFFER after loading: position = " + BUFFER.position()
                + "\tLimit = " + BUFFER.limit() + "\tcapacity = "
                + BUFFER.capacity());

//        for (int i = 0x2500; i <= 0x257F; i++) {
//            System.out.printf("0x%x : %c\n", i, (char) i);
//        }
    }
}
