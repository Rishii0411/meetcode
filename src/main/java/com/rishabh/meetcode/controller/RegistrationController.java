package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.model.User;
import com.rishabh.meetcode.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class RegistrationController {

    private final UserService userService;

    @GetMapping("/register")
    public String showRegistrationPage(Model model) {

        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute User user, Model model) {

        try {
            userService.registerUser(user);
            return "redirect:/login";
        } catch (RuntimeException exception) {
            model.addAttribute("registrationError", exception.getMessage());
            return "register";
        }
    }


    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }
}
