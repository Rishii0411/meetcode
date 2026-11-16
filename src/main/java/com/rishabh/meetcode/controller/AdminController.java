
package com.rishabh.meetcode.controller;

import com.rishabh.meetcode.model.Problem;
import com.rishabh.meetcode.service.ProblemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final ProblemService problemService;

    @GetMapping("/dashboard")
    public String showAdminDashboard(Model model) {

        List<Problem> inactiveProblems =
                problemService.getInactiveProblems();

        model.addAttribute("inactiveProblems", inactiveProblems);

        return "admin-dashboard";

    }

    @PostMapping("/problems/{id}/reactivate")
    public String reactivateProblem(@PathVariable Long id) {

        problemService.reactivateProblem(id);

        return "redirect:/admin/dashboard";
    }

    @PostMapping("/problems/{id}/delete")
    public String permanentlyDeleteProblem(@PathVariable Long id) {

        problemService.permanentlyDeleteProblem(id);

        return "redirect:/admin/dashboard";
    }


}
