/*
 */
package com.cleverfishsoftware.services.common;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

/**
 *
 * @author peter
 */
public class ContentGeneratorDynamic implements ContentGenerator {

    final static int MAX_SIZE = CommonUtils.ONE_MB * 10;

    @Override
    public int getMaxLength() {
        return MAX_SIZE;
    }

    @Override
    public void write(OutputStream os, int size) throws IOException {
        int s = size < 0 ? 0 : size;
        if (s > MAX_SIZE) {
            s = MAX_SIZE;
        }
        char[] buffer = new char[4096];

        char white_smiley = '\u263A';
        char black_smiley = '\u263B';

        int count = 0;
        boolean even = false;
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(os));
        while (count < s) {
            if (even) {
                bw.write(white_smiley);
            } else {
                bw.write(black_smiley);
            }
            even = !even; 
            count+=2; 
        }

    }

    public static void main(String... args) throws IOException {
        ContentGenerator cg = new ContentGeneratorDynamic();
        cg.write(System.out, 100);
        //System.out.println();
    }

}
