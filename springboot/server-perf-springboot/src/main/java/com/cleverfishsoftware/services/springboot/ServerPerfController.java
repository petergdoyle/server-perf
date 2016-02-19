/*
 */
package com.cleverfishsoftware.services.springboot.undertow;

import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicInteger;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController

@RequestMapping("/springboot")

public class ServerPerfController {

    private final static AtomicInteger COUNT = new AtomicInteger();
    
    @Autowired
    private ServerPerfService service;

    @RequestMapping("/perf")
    public String perf() {
        return this.service.getMessage();
    }

    @RequestMapping("/perf/async")
    public Callable<String> perfAsync() {
        return () -> "async: "
                + ServerPerfController.this.service.getMessage();

    }

}
