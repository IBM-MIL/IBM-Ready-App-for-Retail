package com.ibm.mil.summit.model;

import java.util.Map;
import com.google.gson.Gson;

public class StoreClient {

	public String getImage() {
		return this.image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	
	
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

	private String image;
	private int store_number;
	private String location;
	private String address;
	private Map<String, Object> store_hours;
	private String phone_number;
	private Map<String, Object> departments;

	public StoreClient(StoreDB store) {
		this.image = store.getImage();
		this.store_number = store.getStore_number();
		this.location = store.getLocation();
		this.address = store.getAddress();
		this.store_hours = store.getStore_hours();
		this.phone_number = store.getPhone_number();
		this.departments = store.getDepartments();
		
	}
	
	public String toString() {

		Gson gson = new Gson();
		String json = gson.toJson(this);
		return json;

	}

}
