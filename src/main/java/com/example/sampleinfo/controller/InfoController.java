package com.example.sampleinfo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InfoController {
	@GetMapping("/info")
    public String getInfo() {
        return "Welcome to the Sample Info Page! This is a simple Spring Boot app.";
    }

}
