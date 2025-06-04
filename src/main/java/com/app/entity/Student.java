package com.app.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Email;

@Entity
@Data
@NoArgsConstructor
@Table(name="stud_info")
public class Student {
	
@jakarta.persistence.Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
 protected Long Id;

@NotEmpty
protected String name;
@Email
protected String email;
@NotEmpty
protected String address;



}
