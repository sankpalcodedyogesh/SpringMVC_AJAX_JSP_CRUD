package com.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.entity.Student;
import com.app.repository.StudentRepository;

@Service
public class StudentService {
	@Autowired
	protected StudentRepository repository;

	public List<Student> getAllStudent() {
		return repository.findAll();
	}

	public Student getStudentById(Long id) {
		return repository.findById(id)
				.orElseThrow(() -> new IllegalArgumentException("Student not found with ID: " + id));
	}

	public void saveStudent(Student student) {
		repository.save(student);
	}

	public void deleteStudentById(Long id) {
		repository.deleteById(id);
	}
	
	
}
