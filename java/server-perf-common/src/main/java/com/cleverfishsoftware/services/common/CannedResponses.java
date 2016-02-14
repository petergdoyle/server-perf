/*
 */
package com.cleverfishsoftware.services.common;

import static com.cleverfishsoftware.services.common.CommonUtils.getRandomInteger;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

/**
 *
 * @author peter
 */
public final class CannedResponses {

    private static final int DB_SIZE = 10;

    private static final ArrayList<String> DB = new ArrayList(DB_SIZE);
    private static CannedResponses INSTANCE;

    private CannedResponses() {
    }

    public static CannedResponses getInstance() {
        return INSTANCE;
    }

    static {
        INSTANCE = new CannedResponses();
        BufferedReader reader = null;
        try {
            InputStream is = CannedResponses.class.getClassLoader().getResourceAsStream("canned_responses.dat");
            reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String line;
            while ((line = reader.readLine()) != null) {
                DB.add(line);
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException ex) {
                //System.out.println(ex);
            }
        }
    }

    public int size() {
        return DB.size();
    }

    public boolean isEmpty() {
        return DB.isEmpty();
    }

    public byte[] get(int index) throws IndexOutOfBoundsException {
        return DB.get(index).getBytes();
    }

    public byte[] any() {
        int index = getRandomInteger(0, DB_SIZE - 1);
        return DB.get(index).getBytes();
    }

}
