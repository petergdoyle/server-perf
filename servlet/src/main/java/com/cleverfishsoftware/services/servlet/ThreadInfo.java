/*
 */
package com.cleverfishsoftware.services.servlet;

/**
 *
 * @author peter
 */
public class ThreadInfo {

    private final String name;
    private final long id;
    private final String servletName;
    private final long startTime;

    ThreadInfo(final String servletName, final Thread t, long startTime) {
        this.servletName = servletName;
        this.startTime = startTime;
        this.name = t.getName();
        this.id = t.getId();
        System.out.println(servletName + " Start::Name="
                + name + "::ID="
                + id
        );
    }

    void done() {
        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + name + "::ID="
                + id + "::Time Taken="
                + (endTime - startTime) + " ms.");

    }
}