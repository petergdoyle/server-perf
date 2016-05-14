/*

 */
package com.cleverfishsoftware.serverperf.compression.gz;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.GZIPOutputStream;

/**
 *
 * @author peter
 */
public class GZCompressor {

    public static void main(String[] args) throws IOException {
            

        byte[] buffer = new byte[1024];

        String OUTPUT_GZIP_FILE = null;
        String SOURCE_FILE = null;

        try (GZIPOutputStream gzos = new GZIPOutputStream(new FileOutputStream(OUTPUT_GZIP_FILE)); FileInputStream in = new FileInputStream(SOURCE_FILE)) {

            int len;
            while ((len = in.read(buffer)) > 0) {
                gzos.write(buffer, 0, len);
            }

            gzos.finish();
        }

    }

}
