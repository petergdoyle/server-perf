/*
 */
package com.cleverfishsoftware.services.springboot.undertow;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ServerPerfApplication {

    public static void main(String[] args) throws Exception {
        SpringApplication.run(ServerPerfApplication.class, args);
    }

}
