/*
 */
package com.cleverfishsoftware.serverperf.compression.snappy;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.compress.CompressionCodec;
import org.apache.hadoop.util.ReflectionUtils;
import org.xerial.snappy.SnappyCodec;

/**
 *
 * @author peter
 */
public class SnappyCompressor {

    public static void main(String[] args) throws IOException {
        if (args.length < 2) {
            System.out.println("Enterut>  <output>");
            System.exit(0);
        }

        CompressionCodec codec;
        codec = (CompressionCodec) ReflectionUtils
                .newInstance(SnappyCodec.class, new Configuration() {
                });
        try (OutputStream outStream = codec
                .createOutputStream(new BufferedOutputStream(
                        new FileOutputStream(args[1]))); InputStream inStream = new BufferedInputStream(new FileInputStream(
                args[0]))) {
            int readCount;
            byte[] buffer = new byte[64 * 1024];
            while ((readCount = inStream.read(buffer)) > 0) {
                outStream.write(buffer, 0, readCount);
            }
        }
    }
}
