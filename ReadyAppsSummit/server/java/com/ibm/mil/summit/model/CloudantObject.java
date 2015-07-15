package com.ibm.mil.summit.model;

public class CloudantObject {

	private String _id;
	private String type;
	private String _rev;
	private String image;

	public CloudantObject(String type) {
		super();
		this.type = type;
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
	
	
	public String getImageUrl() {
		String path = "product/";
		if ("coupon".equals(getType())) {
			path = "coupon/";
		}
		if ("department".equals(this.getType())){ 
			path = "department/";
		}
		if ("store".equals(this.getType())){
			path = "store/";
		}
		return "apps/services/preview/SummitHtml/common/1.0/default/images/" + path + image;
	}
}
