/*
 */
package com.cleverfishsoftware.services.springboot.undertow;

import java.util.concurrent.Callable;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController

@RequestMapping("/springboot")

public class SampleController {

    @Autowired
    private HelloWorldService helloWorldService;

    @RequestMapping("/perf")
    public String helloWorld() {
        return this.helloWorldService.getHelloMessage();
    }

    @RequestMapping("/perf/async")
    public Callable<String> helloWorldAsync() {
        return () -> "async: "
                + SampleController.this.helloWorldService.getHelloMessage();

    }

}
