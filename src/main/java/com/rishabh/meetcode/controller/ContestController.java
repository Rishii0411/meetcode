package com.rishabh.meetcode.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ContestController {
    @GetMapping("/contests")
    public String contest()
    {
        return "contests";
    }
}
