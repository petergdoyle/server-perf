/*
 */
package com.cleverfishsoftware.services.springboot.undertow;

import org.springframework.stereotype.Component;

@Component
public class ServerPerfService {

    //@Value("${name:World}")
    private String name;

    public String getMessage() {
        return "Hello " + this.name;
    }

}
