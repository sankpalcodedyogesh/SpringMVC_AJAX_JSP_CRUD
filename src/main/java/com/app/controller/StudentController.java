package com.app.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.app.entity.Student;
import com.app.service.EmailService;
import com.app.service.StudentService;

@Controller
@RequestMapping("/students")
public class StudentController {

    @Autowired
    protected StudentService service;
    
    @Autowired
    protected EmailService emailService;

    @GetMapping
    public String frontPage() {
        return "homePage";
    }

    @GetMapping("/studentList")
    @ResponseBody
    public List<Student> studentList() {
        return service.getAllStudent();
    }

    @PostMapping("/saveStudent")
    @ResponseBody
    public String saveStudent(@RequestBody Student student) {
        service.saveStudent(student);
        emailService.sendEmail(
                student.getEmail(),
                "Welcome to the Portal",
                "Dear " + student.getName() + ", your student record has been created successfully."
            );

            return "Saved and email sent";
    }

    @GetMapping("/studentById/{id}")
    @ResponseBody
    public Student findStudentById(@PathVariable Long id) {
        return service.getStudentById(id);
    }


    @DeleteMapping("/deleteStudent/{id}")
    @ResponseBody
    public void deleteStudent(@PathVariable("id") Long id) {
        service.deleteStudentById(id);
    }
    
    @PutMapping("/updateStudent")
    @ResponseBody
    public void updateStudent(@RequestBody Student student) {
        service.saveStudent(student); 
    }
    

}
