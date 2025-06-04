package com.app.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.app.entity.Student;
import com.app.service.StudentService;

@Controller
@RequestMapping("/")
public class StudentController {

    @Autowired
    protected StudentService service;

    @GetMapping
    public String frontPage() {
        return "homePage";
    }

    @GetMapping("/studentList")
    @ResponseBody
    public List<Student> studentList() {
        return service.getAllStudent();
    }

//    @GetMapping("/addStudentPage")
//    public String getAddPage() {
//        return "addStudent";
//    }

    @PostMapping("/saveStudent")
    @ResponseBody
    public void saveStudent(@RequestBody Student student) {
        service.saveStudent(student);
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
