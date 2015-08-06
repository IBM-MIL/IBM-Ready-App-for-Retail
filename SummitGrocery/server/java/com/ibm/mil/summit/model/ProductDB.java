package com.ibm.mil.summit.model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.cloudant.client.api.model.Attachment;
import com.google.gson.Gson;

public class ProductDB extends CloudantObject {

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getColor(){
		return color;
	}
	
	public void setColor(String color) {
		this.color = color;
	}
	
	public String getHexColor(){
		return hexColor;
	}
	
	public void setHexColor(String hexColor) {
		this.hexColor = hexColor;
	}
	
	public Map<String, Map<String, Double>> getAvailability(){
		return availability;
	}
	
	public void setAvailability(Map<String, Map<String, Double>> availability){
		this.availability = availability;
	}

	public int getReviews() {
		return reviews;
	}

	public void setReviews(int reviews) {
		this.reviews = reviews;
	}

	public boolean isRecommended() {
		return isRecommended;
	}

	public void setRecommended(boolean isRecommended) {
		this.isRecommended = isRecommended;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String[] getCategory() {
		return category;
	}

	public void setCategory(String[] category) {
		this.category = category;
	}

	public byte[] getBase64EncodedImage() {
		return base64EncodedImage;
	}

	public void setBase64EncodedImage(byte[] base64EncodedImage) {
		this.base64EncodedImage = base64EncodedImage;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public BigDecimal getSalePrice() {
		return salePrice;
	}

	public void setSaleprice(BigDecimal salePrice) {
		this.salePrice = salePrice;
	}

	public Map<String, Attachment> getAttachments() {
		return _attachments;
	}

	public void setAttachments(Map<String, Attachment> attachments) {
		this._attachments = attachments;
	}

	public Map<String, String> getSubCategory() {
		return subCategory;
	}

	public void setSubCategory(Map<String, String> subCategory) {
		this.subCategory = null;
		if (subCategory != null) {
			this.subCategory = new HashMap<String, String>(subCategory);
		}
	}

	private String description;
	private String color;
	private String hexColor;
	private Map<String, Map<String, Double>> availability;
	private int reviews;
	private boolean isRecommended;
	private int rating;
	private String department;
	private String[] category;
	private Map<String, Attachment> _attachments;
	private byte[] base64EncodedImage;
	private BigDecimal price;
	private BigDecimal salePrice;
	private Map<String, String> subCategory;

	private String name;

	public ProductDB(String type) {
		super(type);
	}

	public String toString() {
		Gson gson = new Gson();
		return gson.toJson(this);
	}
}
