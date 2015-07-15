package com.ibm.mil.summit.model;

import com.google.gson.Gson;

public class DepartmentClient {
	public String getId() {
		return _id;
	}
	
	public void setId(String _id) {
		this._id = _id;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
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
	
	public void setImageUrl(String url) {
		this.imageUrl = url;
	}
	public String getImageurl() {
		return this.imageUrl;
	}
	
	private String _id;
	private String title;
	private int aisle;
	private boolean isFeatured;
	private String type;
	private String imageUrl;

	public DepartmentClient(HomeView homeView) {
		this._id = homeView.getId();
		this.title = homeView.getTitle();
		this.isFeatured = homeView.isFeatured();
		this.aisle = homeView.getAisle();
		this.type = homeView.getType();
		this.imageUrl = homeView.getImageUrl();
	}

	public DepartmentClient(DepartmentDB dept) {
		this._id = dept.getId();
		this.title = dept.getTitle();
		this.isFeatured = dept.isFeatured();
		this.aisle = dept.getAisle();
		this.type = dept.getType();
		this.imageUrl = dept.getImageUrl();
	}
	
	public String toString() {
		
		Gson gson = new Gson();
		String json= gson.toJson(this);
		return json;
	}

}
