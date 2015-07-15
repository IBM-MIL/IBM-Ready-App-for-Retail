package com.ibm.mil.summit.model;

import com.google.gson.Gson;

public class CouponClient {
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
	
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	public String getImageUrl() {
		return this.imageUrl;
	}
	
	public void setImageUrl(String url) {
		this.imageUrl = url;
	}

	private String _id;
	private String text;
	private String type;
	private String imageUrl;

	public CouponClient(HomeView homeView) {
		this._id = homeView.getId();
		this.text = homeView.getText();
		this.type = homeView.getType();
		this.imageUrl = homeView.getImageUrl();
	}
	
	public CouponClient(CouponDB coupon) {
		this._id = coupon.getId();
		this.text = coupon.getText();
		this.type = coupon.getType();
		this.imageUrl = coupon.getImageUrl();
	}

	public String toString() {
		Gson gson = new Gson();
		String json= gson.toJson(this);
		return json;
	}

}
