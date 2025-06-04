package com.app.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@ComponentScan(basePackages = "com.app")
@EnableJpaRepositories(basePackages = "com.app.repository")
@EnableTransactionManagement
@PropertySource("classpath:application.properties")
public class DbConfig {

	@Autowired
	Environment env;
	
	@Bean
	public DataSource dataSource() {
		DriverManagerDataSource ds = new DriverManagerDataSource();
		ds.setDriverClassName(env.getProperty("jdbc.driverClassName"));
        ds.setUrl(env.getProperty("jdbc.url"));
        ds.setUsername(env.getProperty("jdbc.username"));
        ds.setPassword(env.getProperty("jdbc.password"));
        return ds;
	}
	
	 @Bean
	    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
	        LocalContainerEntityManagerFactoryBean emf = new LocalContainerEntityManagerFactoryBean();
	        emf.setDataSource(dataSource());
	        emf.setPackagesToScan("com.app.entity");
	        emf.setJpaVendorAdapter(new HibernateJpaVendorAdapter());

	        Properties props = new Properties();
	        props.setProperty("hibernate.dialect", env.getProperty("hibernate.dialect"));
	        props.setProperty("hibernate.hbm2ddl.auto", env.getProperty("hibernate.hbm2ddl.auto"));
	        props.setProperty("hibernate.show_sql", env.getProperty("hibernate.show_sql"));
	        props.setProperty("hibernate.format_sql", env.getProperty("hibernate.format_sql"));
	        emf.setJpaProperties(props);

	        return emf;
	    }

	    @Bean
	    public JpaTransactionManager transactionManager() {
	        JpaTransactionManager txManager = new JpaTransactionManager();
	        txManager.setEntityManagerFactory(entityManagerFactory().getObject());
	        return txManager;
	    }
	
}
