package com.ibm.mil.summit.model;

public class MinMetaData extends CloudantObject {
	private String imageUrl;
	
	public String getImageUrl() {
		return this.imageUrl;
	}
	
	public void setImageUrl(String url) {
		this.imageUrl = url;
	}
	
	public MinMetaData(HomeView hv) {
		super(hv.getType());
		this.setId(hv.getId());
		this.set_rev(hv.get_rev());
		this.imageUrl = hv.getImageUrl();
	}
}
