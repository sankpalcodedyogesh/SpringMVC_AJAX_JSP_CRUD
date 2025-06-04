package com.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="users")
@Data
@NoArgsConstructor
@Getter
@Setter
public class User {

	@jakarta.persistence.Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	protected Long Id;
	
	@Column(unique = true , nullable = false)
	protected String username;
	
	@Column(nullable = false)
	protected String password;
	
	private String role;

	private boolean enabled = true;
}
