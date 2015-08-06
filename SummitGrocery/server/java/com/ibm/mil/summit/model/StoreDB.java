package com.ibm.mil.summit.model;

import java.util.Map;

public class StoreDB extends CloudantObject {
	
	private int store_number;
	public int getStore_number() {
		return store_number;
	}

	public void setStore_number(int store_number) {
		this.store_number = store_number;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Map<String, Object> getStore_hours() {
		return store_hours;
	}

	public void setStore_hours(Map<String, Object> store_hours) {
		this.store_hours = store_hours;
	}

	public String getPhone_number() {
		return phone_number;
	}

	public void setPhone_number(String phone_number) {
		this.phone_number = phone_number;
	}

	public Map<String, Object> getDepartments() {
		return departments;
	}

	public void setDepartments(Map<String, Object> departments) {
		this.departments = departments;
	}

	private String location;
	private String address;
	private Map<String, Object> store_hours;
	private String phone_number;
	private Map<String, Object> departments;

	public StoreDB(String type) {
		super(type);
	}
}
