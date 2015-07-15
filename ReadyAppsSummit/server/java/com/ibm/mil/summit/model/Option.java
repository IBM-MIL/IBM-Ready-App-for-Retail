package com.ibm.mil.summit.model;

import java.util.ArrayList;
import java.util.List;

public class Option {
	private List<Object> values;
	public void setValues(List<Object> values) {
		this.values = null;
		if(values != null) {
			this.values = new ArrayList<Object>(values);
		}
	}
	public List<Object> getValues() {
		return this.values;
	}
	
	public Option () {
	}
	public Option (Option options) {
		this.setValues(options.getValues());
	}
}
