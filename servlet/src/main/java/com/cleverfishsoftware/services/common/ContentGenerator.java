/*
 */
package com.cleverfishsoftware.services.common;

import java.io.IOException;
import java.io.OutputStream;

/**
 *
 * @author peter
 */
public interface ContentGenerator {

    
    int getMaxLength();

    void write(OutputStream os, final int size) throws IOException;
    
}
