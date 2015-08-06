package com.ibm.mil.summit.model;

public class CouponDB extends CloudantObject {

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	private String text;
	
	public CouponDB(String type) {
		super(type);
	}
}
