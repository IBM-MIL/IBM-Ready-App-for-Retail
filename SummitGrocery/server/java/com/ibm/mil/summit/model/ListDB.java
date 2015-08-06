package com.ibm.mil.summit.model;

import java.util.List;

import com.google.gson.Gson;

public class ListDB extends CloudantObject {

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<String> getItems() {
		return items;
	}

	public void setItems(List<String> items) {
		this.items = items;
	}

	private String title;
	private List<String> items;

	public ListDB(String type) {
		super(type);
	}

	public String toString() {
		Gson gson = new Gson();
		return gson.toJson(this);
	}
}
