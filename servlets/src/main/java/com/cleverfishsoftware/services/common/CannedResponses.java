/*
 */
package com.cleverfishsoftware.services.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author peter
 */
public final class CannedResponses {

    private static ArrayList<String> db;
    private static final Random RANDOM = new Random();
    private  static int MIN = 0;
    private  static int MAX;

    private CannedResponses() {
    }

    public static CannedResponses getInstance() {
        return new CannedResponses();
    }

    static {
        BufferedReader reader = null;
        try {
            db = new ArrayList(10);
            InputStream is = CannedResponses.class.getClassLoader().getResourceAsStream("canned_responses.dat");
            reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String line;
            while ((line = reader.readLine()) != null) {
                db.add(line);
            }
            CannedResponses.MAX = db.size() - 1;
        } catch (UnsupportedEncodingException ex) {
            System.out.println(ex);
            db = new ArrayList(0);
        } catch (IOException ex) {
            System.out.println(ex);
            db = new ArrayList(0);
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException ex) {
                System.out.println(ex);
            }
        }
    }

    public int size() {
        return db.size();
    }

    public boolean isEmpty() {
        return db.isEmpty();
    }

    public byte[] get(int index) throws IndexOutOfBoundsException {
        return db.get(index).getBytes();
    }

    public byte[] any() {
        int index = RANDOM.nextInt(MAX - MIN + 1) + MIN;
        return db.get(index).getBytes();
    }

}
