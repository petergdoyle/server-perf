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
    private boolean quiet;

    ThreadInfo(final String servletName, final Thread t, long startTime, boolean quiet) {
        this(servletName, t, startTime);
        this.quiet = quiet;
    }

    ThreadInfo(final String servletName, final Thread t, long startTime) {
        this.servletName = servletName;
        this.startTime = startTime;
        this.name = t.getName();
        this.id = t.getId();
        this.quiet = true;
        if (!quiet) {
            System.out.println(servletName + " Start::Name="
                    + name + "::ID="
                    + id
            );
        }
    }

    void done() {
        long endTime = System.currentTimeMillis();
        if (!quiet) {
            System.out.println(servletName + " End::Name="
                    + name + "::ID="
                    + id + "::Time Taken="
                    + (endTime - startTime) + " ms.");
        }
    }

    @Override
    public String toString() {
        return "ThreadInfo{" + "name=" + name + ", id=" + id + ", servletName=" + servletName + ", startTime=" + startTime + ", quiet=" + quiet + '}';
    }
}
