package com.ibm.mil.summit.database;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.cloudant.client.api.CloudantClient;
import com.cloudant.client.api.Database;
import com.google.gson.Gson;
import com.ibm.mil.summit.model.CouponClient;
import com.ibm.mil.summit.model.CouponDB;
import com.ibm.mil.summit.model.DepartmentClient;
import com.ibm.mil.summit.model.DepartmentDB;
import com.ibm.mil.summit.model.HomeView;
import com.ibm.mil.summit.model.ListDB;
import com.ibm.mil.summit.model.MinMetaData;
import com.ibm.mil.summit.model.ProductClient;
import com.ibm.mil.summit.model.ProductDB;
import com.ibm.mil.summit.model.StoreClient;
import com.ibm.mil.summit.model.StoreDB;
import com.ibm.mil.summit.model.UserDB;

/**
 **************************************************************************************************************** 
 * This class communicates with Cloudant and returns relevant information for
 * the user who has been properly authenticated. The functions in this class
 * will be invoked via the MobileFirst Platform Adapters.
 **************************************************************************************************************** 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

public class CloudantConnector {

	// single instance of CloudantConnector
	private static CloudantConnector cloudantConnector;
	private static final Double UNAVAILABLE = new Double(0.0);
	private String username = "c38f4c98-da63-41be-b62f-48b5934da36d-bluemix";
	private String password = "92fd5f89e181388e381055501d3d894212c02efd017e2551fed276f4d8feefba";
	private String dbName = "grocery_db";
	private CloudantClient cloudant;
	private Database db;
	public static String DEFAULT_LOCALE = "en";

	// Logger class for logging output
	private static final Logger LOGGER = Logger
			.getLogger(CloudantConnector.class.getSimpleName());

	public CloudantConnector() {
		super();
		connect();
	}

	private void connect() {
		// Create cloudant client
		cloudant = new CloudantClient(username, username, password);
		// Get reference to database
		db = cloudant.database(dbName, true);
	}

	/**
	 * Get user ID by username.
	 * 
	 * @return User ID by username.
	 * @param username
	 */
	public String getUserID(String username) {
		List<UserDB> users = db.view("retailDesignDoc/userInfo").key(username)
				.includeDocs(true).query(UserDB.class);
		String userID = null;
		if (users != null && users.size() > 0 ) {
			userID = users.get(0).getId();
		}
		
		return userID;

	}

	/**
	 * Get all stores.
	 * 
	 * @return all stores in the database.
	 */
	public String getAllStores(String userLocale) {
		List<StoreDB> stores = db.view("retailDesignDoc/storeData")
				.includeDocs(true).query(StoreDB.class);
		List<StoreClient> allStores = new ArrayList<StoreClient>();
		for (StoreDB store : stores) {
			allStores.add(new StoreClient(store));
		}

		return new Gson().toJson(allStores);
	}

	/**
	 * Get all meta data for the landing page view.
	 * 
	 * @return meta data for the landing page.
	 * @param userLocale
	 */
	public String getHomeViewMetaData(String userLocale) {
		Map<String, Object> lists = new HashMap<String, Object>();

		LOGGER.info("userLocale: " + userLocale);
		List<HomeView> homeScreenData = db
		// what database to look at
				.view("retailDesignDoc/homeViewData").includeDocs(true).key(userLocale)
				// actually runs the query - inject each result into a Product
				// object
				.query(HomeView.class);
		List<Object> recommended = new ArrayList<Object>();
		List<Object> featured = new ArrayList<Object>();
		List<Object> all = new ArrayList<Object>();

		// traverse over the data we got from the database
		for (HomeView homeView : homeScreenData) {
			// determine what data goes into featured, recommended, and all
			// lists for the home view
			String type = homeView.getType();
			/*
			 * lets handle departments. departments are the only thing that can
			 * be "featured" (for now). If the dept is featured it shouldnt be
			 * included in all, otherwise lets stuff it in all.
			 */
			if ("department".equals(type)) {
				// is it featured? then put in featured list, if not put in all
				// list
				if (homeView.isFeatured()) {
					featured.add(new MinMetaData(homeView, userLocale));
				} else {
					if (homeView.getImage() != null) {
						all.add(new MinMetaData(homeView, userLocale));
					}
				}
			}
			/*
			 * Coupons are always recommended and always included in all.
			 */
			if ("coupon".equals(type)) {
				recommended.add(new MinMetaData(homeView, userLocale));
				all.add(new MinMetaData(homeView, userLocale));
			}
			/*
			 * Lets handle products, if its recommended we add it to that list,
			 * otherwise just add it to the all list
			 */
			if ("product".equals(type)) {
				if (homeView.isRecommended()) {
					recommended.add(new MinMetaData(homeView, userLocale));
				}
				all.add(new MinMetaData(homeView, userLocale));
			}
		}

		// return a map with a key of featured, recommended, and all
		lists.put("featured", featured);
		lists.put("recommended", recommended);
		lists.put("all", all);

		return new Gson().toJson(lists);
	}

	/**
	 * Retrieves a product from the database by product id. Output is not
	 * formatted for MFP adapter, for proper formatting call getProductById()
	 * instead.
	 * 
	 * @param productId
	 *            The product to return.
	 * @return The product with the corresponding productId, or null if no
	 *         product was found with that id.
	 */
	private Object getProductObjectById(String productId, String userLocale) {
		Object productObject = null;
		if (productId != null && !"".equals(productId)) {
			List<ProductDB> products2 = db.view("retailDesignDoc/products").key(productId, userLocale)
					.includeDocs(true).query(ProductDB.class);
			//ProductDB product = db.find(ProductDB.class, productId);
			if (products2 != null && products2.size() > 0) {
				ProductDB product = products2.get(0);
				Gson gson = new Gson();
				//ArrayList<ColorOption> options = new ArrayList<ColorOption>();
				// 1. Query for all product from cloudant
				// 3. Create productClient object from product object
				// 4. Add list of "optional"fields to product client object
				ProductClient pc = new ProductClient(product, gson.fromJson(
						getDepartmentById(product.getDepartment(), userLocale),
						DepartmentClient.class), userLocale);
				//pc.setColorOptions(options);
				// 5. jsonify productclient and send to client.
				productObject = pc;
			}
		}

		return productObject;
	}

	/**
	 * Retrieves a product from the database by product id. Output is formatted
	 * to fit the MFP adapter.
	 * 
	 * @param productId
	 *            The product to return.
	 * @param userLocale
	 * 
	 * @return The product with the corresponding productId, or null if no
	 *         product was found with that id.
	 */
	public String getProductById(String productId, String userLocale) {
		Gson gson = new Gson();
		return gson.toJson(getProductObjectById(productId, userLocale));
	}

	/**
	 * Retrieves a store from the database by store id.
	 * 
	 * @param storeId
	 *            The store to return.
	 * @param userLocale
	 *             
	 * @return The product with the corresponding storeId, or null if no store
	 *         was found with that id.
	 */
	public String getStoreById(String storeId, String userLocale) {
		String storeJson = null;
		if (storeId != null && !"".equals(storeId)) {
			List<StoreDB> stores = db.view("retailDesignDoc/storeData").key(storeId)
					.includeDocs(true).query(StoreDB.class);
			if (stores != null && stores.size() > 0) {
				storeJson = new Gson().toJson(new StoreClient(stores.get(0)));
			}
		}

		return storeJson;
	}

	/**
	 * Retrieves a coupon from the database by id.
	 * 
	 * @param couponId
	 *            The product to return.
	 * @param userLocale
	 * 
	 * @return The product with the corresponding productId, or null if no
	 *         product was found with that id.
	 */
	public String getCouponById(String couponId, String userLocale) {
		String json = null;
		if (couponId != null && !"".equals(couponId)) {
			List<CouponDB> coupons = db.view("retailDesignDoc/Coupons")
					.key(couponId, userLocale).includeDocs(true).
					query(CouponDB.class);
			if (coupons != null && coupons.size() > 0) {
				json = new Gson().toJson(new CouponClient(coupons.get(0), 
						userLocale));
			}
		}

		return json;
	}

	/**
	 * Retrieves a department from the database by id.
	 * 
	 * @param departmentId
	 *            The product to return.
	 * @param userLocale
	 * 
	 * @return The product with the corresponding productId, or null if no
	 *         product was found with that id.
	 */
	public String getDepartmentById(String departmentId, String userLocale) {
		String json = null;
		if (departmentId != null && !"".equals(departmentId)) {
			List<DepartmentDB> departments = db.view("retailDesignDoc/departments").key(departmentId, userLocale)
					.includeDocs(true).query(DepartmentDB.class);
			if (departments != null && departments.size() > 0) {
				json = new Gson().toJson(new DepartmentClient(
						departments.get(0), userLocale));
			}
		}

		return json;
	}
	
	/**
	 * authenticates the user logging in and returns a patient object
	 * 
	 * @param username
	 * @param password
	 * @return valid DBObject
	 */
	public int verifyUser(String username, String password) {
		// Sanity check for: null, empty, sql query, etc
		boolean sanityVerificationforUsername = sanityCheck(username);

		// Sanity check for: null, empty, sql query, etc
		boolean sanityVerificationforPassword = sanityCheck(password);
		LOGGER.info("username: " + username + ", pass: " + password +", sanity1: " + sanityVerificationforUsername + ", sanity2: " + sanityVerificationforPassword);
		int validUser = 0;
		if (sanityVerificationforUsername && sanityVerificationforPassword) {
			List<UserDB> users = db.view("retailDesignDoc/userInfo").key(username).includeDocs(true).query(UserDB.class);
			if (users != null && users.size() > 0) {
				UserDB user = users.get(0);
				LOGGER.info("user: " + user + ", up: '" + user.getPassword() + "', form: '" + password + "'");
					
				if (password.equals(user.getPassword())) {
					validUser = 1;
				} else {
					validUser = 2;
				}
			}
		}
		
		return validUser;
	}

	/**
	 * Get all departments.
	 * 
	 * @return all departments in the database.
	 */
	public String getAllDepartments(String userLocale) {
		List<DepartmentDB> departments = db.view("retailDesignDoc/departments")
				.includeDocs(true).query(DepartmentDB.class);
		List<DepartmentClient> allDepartments = new ArrayList<DepartmentClient>();
		for (DepartmentDB department : departments) {
			allDepartments.add(new DepartmentClient(department, userLocale));
		}

		/*
		 * Rearranging departments so that we can demo beacons better.
		 */
		DepartmentClient mensBoots = allDepartments.remove(allDepartments.size() - 1);
		DepartmentClient winterSports = allDepartments.remove(3);
		DepartmentClient campingEssentials = allDepartments.remove(2);

		allDepartments.add(0, mensBoots);
		allDepartments.add(0, winterSports);
		allDepartments.add(0, campingEssentials);

		return new Gson().toJson(allDepartments);
	}

	private static class UserList {
		String name;
		List<ProductClient> products;
	}
	
	/**
	 * Get the lists associated with a given user
	 * 
	 * @param userId
	 * @param userLocale
	 * 
	 * @return defaultList - the list of products for user by ID.
	 */
	public String getDefaultList(String userId, String userLocale) {
		List<ListDB> userListObject = new ArrayList<ListDB>();
		UserDB user = db.find(UserDB.class, userId);
		List<String> userListIds;
		List<UserList> userLists = new ArrayList<UserList>();

		if (user.getList() != null) {
			userListIds = user.getList().get(userLocale);

			for (String userList : userListIds) {
				userListObject.add(db.find(ListDB.class, userList));
			}
			// insert product object in each object in items array
			for (ListDB listObject : userListObject) {
				List<String> prodIds = listObject.getItems();
				List<ProductClient> prods = new ArrayList<ProductClient>();

				for (String prodId : prodIds) {
					ProductClient p = (ProductClient) this.getProductObjectById(prodId, userLocale);
					prods.add(p);
				}

				UserList userList = new UserList();
				userList.name = listObject.getTitle();
				userList.products = prods;
				userLists.add(userList);
			}
		}

		return new Gson().toJson(userLists);

	}

	/**
	 * Check to see if a product is available in the size in the user's store.
	 * 
	 * @param userid
	 * @param productID
	 * @param userLocale
	 * 
	 * @return entryValue - the sizes and the number of items in stock
	 */
	private boolean productIsAvailable(String userid, String productID,
			String userLocale) {
//		Object entryValue = null;
		boolean availability = false;
		// get the users store
		// query data
		List<UserDB> userData = db.view("retailDesignDoc/userById").key(userid)
				.includeDocs(true).query(UserDB.class);
		// traverse the users to get the right one out
		String userStoreId = null;
		if (userData != null && userData.size() > 0) {
			userStoreId = userData.get(0).getMystore();
			LOGGER.info("users storeid: " + userStoreId);
		}

		// get the products info
		List<ProductDB> productData = db.view("retailDesignDoc/products").key(productID, userLocale)
				.includeDocs(true).query(ProductDB.class);
		// traverse the products to get the right one out
		for (ProductDB productDB : productData) {
			// if its the productid that was passed
			// Check to see if any stores have availability by checking quantities at all stores listed.
			Map<String, Map<String, Double>> prodAvailability = productDB.getAvailability();
			if (prodAvailability.containsKey(userStoreId)) {
				Map<String, Double> optionAvailability = prodAvailability.get(userStoreId);
				//There should only be one option for the products so this should be 
				for (Double value : optionAvailability.values()) {
					if (UNAVAILABLE.doubleValue() != value.doubleValue()) {
						availability = true;
					}
				}
			}
		}
		return availability;
	}

	/*
	 * Ensures that the data sent from the client is correct...right now only checking that the parameters are not
	 * null and that they do not contain the empty string.
	 */
	private boolean sanityCheck(String argument) {
		// check for null, empty, sql query, etc
		boolean isValid = true;
		if (argument == null) {
			isValid = false;
		} else if (argument.equals("")) {
			isValid = false;
		}

		return isValid;
	}

	/**
	 * returns one and only one instance of the CloudantConnector class
	 * 
	 * @return CloudantConnector instance
	 */
	public static synchronized CloudantConnector getInstance() {
		if (cloudantConnector == null) {
			cloudantConnector = new CloudantConnector();
		}
		return CloudantConnector.cloudantConnector;
	}
};