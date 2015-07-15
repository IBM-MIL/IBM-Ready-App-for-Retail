package com.ibm.mil.summit.model;

public class ColorOption {
	private String color;
	private String hexColor;
	private String url;
	private String productID;
	
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getHexColor() {
		return hexColor;
	}
	public void setHexColor(String hexColor) {
		this.hexColor = hexColor;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String get_id() {
		return productID;
	}
	public void set_id(String _id) {
		this.productID = _id;
	}
	
	public ColorOption (ProductDB prod) {
		this.url = prod.getImageUrl();
		this.productID = prod.getId();
		this.color = prod.getColor();
		this.hexColor = prod.getHexColor();
	}
}
