package com.ibm.mil.summit.model;

public class DepartmentDB extends CloudantObject {
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public int getAisle() {
		return aisle;
	}

	public void setAisle(int aisle) {
		this.aisle = aisle;
	}

	public boolean isFeatured() {
		return isFeatured;
	}

	public void setFeatured(boolean isFeatured) {
		this.isFeatured = isFeatured;
	}
	
	private String title;
	private int aisle;
	private boolean isFeatured;
	
	public DepartmentDB(String type) {
		super(type);
	}
}
