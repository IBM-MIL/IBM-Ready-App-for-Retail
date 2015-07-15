package com.ibm.mil.summit.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

public class ProductClient {
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
	
//	public Map<String, Object> getAvailability(){
//		return availability;
//	}
//	
//	public void setAvailability(Map<String, Object> availability){
//		this.availability = availability;
//	}

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

	public DepartmentClient getDepartment() {
		return departmentObj;
	}

	public void setDepartment(DepartmentClient department) {
		this.departmentObj = department;
	}

	public String[] getCategory() {
		return category;
	}

	public void setCategory(String[] category) {
		this.category = null;
		if (category != null) {
			this.category = new String[category.length];
			for (int i = 0 ; i < category.length; ++i ) {
				this.category[i] = category[i];
			}
		}
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}

	public BigDecimal getPrice() {
		return priceRaw;
	}

	public void setPrice(BigDecimal price) {
		this.priceRaw = price;
	}

	public BigDecimal getSalePrice() {
		return salePriceRaw;
	}

	public void setSalePrice(BigDecimal salePrice) {
		this.salePriceRaw = salePrice;
	}

	public void setImageUrl(String url) {
		this.imageUrl = url;
	}
	public String getImageurl() {
		return this.imageUrl;
	}
	
	public void setSubCategory(Map<String, String> map) {
		if (map == null) {
			this.subCategory = null;
		} else {
			this.subCategory = new HashMap<String, String>(map);
		}
	}
	
	public Map<String, String> getSubCategory() {
		return this.subCategory;
	}
	
	public void setColorOptions(List<ColorOption> options) {
		this.colorOptions = null;
		if (options != null) {
			this.colorOptions = new ArrayList<ColorOption>(options);
		}
	}
	
	public List<ColorOption> getColorOptions() {
		return this.colorOptions;
	}
	public void setOption(Option op) {
		this.option = new Option(op);
	}
	public Option getOption() {
		return this.option;
	}
	
	private String name;
	private String description;
	private String color;
	private String hexColor;
	private List<ColorOption> colorOptions;
	//private Map<String, Object> availability;
	private int reviews;
	private boolean isRecommended;
	private int rating;
	private DepartmentClient departmentObj;
	private String[] category;
	private String type;
	private String _id;
	private BigDecimal priceRaw;
	private BigDecimal salePriceRaw;
	private String imageUrl;
	private Map<String, String> subCategory;
	private Option option;
	
	public ProductClient(HomeView homeView, DepartmentClient department) {
		this.name = homeView.getName();
		this.color = homeView.getColor();
		this.hexColor = homeView.getHexColor();
//		this.availability = homeView.getAvailability();
		this.reviews = homeView.getReviews();
		this.isRecommended = homeView.isRecommended();
		this.rating = homeView.getRating();
		this.priceRaw = homeView.getPrice();
		this.salePriceRaw = homeView.getSalePrice();
		this.departmentObj = department;
		this.category = homeView.getCategory();
		this.type = homeView.getType();
		this._id = homeView.getId();
		this.imageUrl = homeView.getImageUrl();
		this.setSubCategory(homeView.getSubCategory());
		this.description = homeView.getDescription();
		this.option = getOptions(homeView);
	}

	public ProductClient(ProductDB prod, DepartmentClient department) {
		this.name = prod.getName();
		this.color = prod.getColor();
		this.hexColor = prod.getHexColor();
//		this.availability = prod.getAvailability();
		this.reviews = prod.getReviews();
		this.isRecommended = prod.isRecommended();
		this.rating = prod.getRating();
		this.priceRaw = prod.getPrice();
		this.salePriceRaw = prod.getSalePrice();
		this.departmentObj = department;
		this.category = prod.getCategory();
		this.type = prod.getType();
		this._id = prod.getId();
		this.imageUrl = prod.getImageUrl();
		this.setSubCategory(prod.getSubCategory());
		this.description = prod.getDescription();
		this.option = getOptions(prod);
	}
	
	private Option getOptions(Object obj) {
		System.out.println("class: " + obj.getClass().getName());
		Map<String, Map<String, Double>> map = null;
		if ("HomeView".equals(obj.getClass().getName())) {
			HomeView hv = (HomeView) obj;
			map = hv.getAvailability();
		} else {
			ProductDB pdb = (ProductDB) obj;
			map = pdb.getAvailability();
		}
		Option op = new Option();
		if (map!=null) {
			List<Object> list = new ArrayList<Object>();
			//Store id is the key into the top level map.
			for (String storeId : map.keySet()) {
				Map<String, Double> storeOptions = map.get(storeId);
				//Size is the key into this second map.
				for (String size: storeOptions.keySet()) {
					list.add(size);
				}
				//Since each store has the list of all sizes, dont need to process more than one store entry.
				break;
			}
			op.setValues(list);
		}
		return op;
	}

	public String toString() {

		Gson gson = new Gson();
		String json = gson.toJson(this);
		return json;

	}

}
