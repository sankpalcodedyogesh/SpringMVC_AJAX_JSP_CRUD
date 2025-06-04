package com.app.controller;

import com.app.entity.User;
import com.app.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/")
public class UserController {

	@Autowired
	private UserService userService;

	@GetMapping
	public String loginPage() {
		return "login";
	}

	@GetMapping("/signup")
	public String signupPage() {
		return "signup";
	}

	@PostMapping("/register")
	public String registerUser(@ModelAttribute User user) {
		userService.register(user); 
		return "redirect:/";
	}

	@PostMapping("/doLogin")
	public String doLogin(@RequestParam("username") String username, @RequestParam("password") String password,
			HttpSession session, Model model) {
		User user = userService.login(username, password);
		if (user != null) {
			session.setAttribute("loggedInUser", user);
			return "redirect:/home";
		} else {
			model.addAttribute("error", "Invalid credentials");
			return "login";
		}
	}

	@GetMapping("/home")
	public String homePage() {
		return "homePage";
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
}
