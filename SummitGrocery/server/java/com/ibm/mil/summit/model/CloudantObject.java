package com.ibm.mil.summit.model;

import com.google.gson.Gson;

public class CloudantObject {

	private String _id;
	private String type;
	private String _rev;
	private String image;
	private String locale;

	public CloudantObject(String type) {
		super();
		this.type = type;
	}

	public String getLocale() {
		return locale;
	}
	
	public void setLocale(String locale) {
		this.locale = locale;
	}
	
	public String getId() {
		return _id;
	}

	public void setId(String _id) {
		this._id = _id;
	}

	public void setType(String type) {
		this.type = type;
	}
	public String getType() {
		return type;
	}

	public String get_rev() {
		return _rev;
	}

	public void set_rev(String _rev) {
		this._rev = _rev;
	}

	
	public String getImage() {
		return this.image;
	}
	
	public void setImage(String image) {
		this.image = image;
	}
	
	
	public String getImageUrl(String locale) {
		String path = "product/";
		if ("coupon".equals(getType())) {
			path = "coupon/" + locale + "/";
		}
		if ("department".equals(this.getType())){ 
			path = "department/"+ locale + "/";
		}
		if ("store".equals(this.getType())){
			path = "store/";
		}
		return "apps/services/preview/SummitHtml/common/1.0/default/images/" + path + image;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}
}
