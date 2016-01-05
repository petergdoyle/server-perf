/*
 */
package com.cleverfishsoftware.services.springboot;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/springboot/perf")

public class ServerPerfController {

    private static final String template = "Hello, %s!";
    private final AtomicLong counter = new AtomicLong();

    @RequestMapping(method = RequestMethod.GET)
    public @ResponseBody
    GenericResponse sayHello(@RequestParam(value = "name", required = false, defaultValue = "Stranger") String name) {
        return new GenericResponse(counter.incrementAndGet(), String.format(template, name));
    }

}
