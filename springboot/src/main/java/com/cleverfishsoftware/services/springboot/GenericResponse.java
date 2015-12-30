/*
 */
package com.cleverfishsoftware.services.springboot;

/**
 *
 * @author peter
 */
public class GenericResponse {

    private final long id;
    private final String content;

    public GenericResponse(long id, String content) {
        this.id = id;
        this.content = content;
    }

    public long getId() {
        return id;
    }

    public String getContent() {
        return content;
    }
}
