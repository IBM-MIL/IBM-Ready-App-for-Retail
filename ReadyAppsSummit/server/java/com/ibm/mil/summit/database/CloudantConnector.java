package com.ibm.mil.summit.database;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.cloudant.client.api.CloudantClient;
import com.cloudant.client.api.Database;
import com.google.gson.Gson;
import com.ibm.mil.summit.model.ColorOption;
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
	private String username = "<your-cloudant-username";
	private String password = "<your-cloudant-password>";
	private String dbName = "<your-db-name>";
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
	 * For testing only
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		CloudantConnector cc = CloudantConnector.getInstance();

		// cc.connect();
		// List<ProductClient> featuredProducts = cc.getFeaturedProducts();
		// for (ProductClient pc : featuredProducts) {
		// System.out.println(pc);

		cc.productIsAvailable("580ababd18def4f7c9aafa4bd2b73ffc",
				"01f31c48b90899b93e65be6913888c70", "en");
		// String allprods = cc.getHomeViewAll(null);
		Gson gson = new Gson();
		// Map<String, Object> response = jp.fromJson(allprods, Map.class);
		// Map<String, Object> = jp.fromJson(response, classOfT);
		// Map<String, Object> homeViewData = cc.getHomeViewData(null);

		// }

		// int rc = cc.verifyUser("fofiase", "oifjea");
		// System.out.println("Return code: " + rc + " (Should return 0)");
		// rc = cc.verifyUser("user1", "foo");
		// System.out.println("Return Code: " + rc + " (Should return 2)");
		// rc = cc.verifyUser("user1", "password1");
		// System.out.println("Return Code: " + rc + " (Should return 1)");

	}

	/**
	 * Get user ID by username.
	 * 
	 * @return User ID by username.
	 * @param username
	 */
	private String getUserID(String username) {
		List<UserDB> users = db.view("retailDesignDoc/userInfo")
				.includeDocs(true).query(UserDB.class);
		String userID = null;
		for (UserDB user : users) {
			if (user.getUsername() != null
					&& user.getUsername().equals(username)) {
				userID = user.getId();

				break;
			}
		}
		return userID;

	}

	/**
	 * Get all stores.
	 * 
	 * @return all stores in the database.
	 */
	private String getAllStores(String userLocale) {
		List<StoreDB> stores = db.view("retailDesignDoc/storeData")
				.includeDocs(true).query(StoreDB.class);
		List<StoreClient> allStores = new ArrayList<StoreClient>();
		for (StoreDB store : stores) {
			StoreClient clientSideStore = new StoreClient(store);

			allStores.add(clientSideStore);
		}
		Gson gson = new Gson();

		return gson.toJson(allStores);
	}

	/**
	 * Get time difference from start to end. For performance testing.
	 * 
	 */
	private String getTimeDifference(long start, long end) {
		long diff = end - start;
		int millis = (int) diff % 1000;
		int sec = (int) diff / 1000;
		int min = (int) diff / 1000 / 60;
		return min + " minutes " + sec + " seconds " + millis + " milliseconds";
	}

	/**
	 * Get all meta data for the landing page view.
	 * 
	 * @return meta data for the landing page.
	 * @param userLocale
	 */
	private String getHomeViewMetaData(String userLocale) {
		Map<String, Object> lists = new HashMap<String, Object>();

		List<HomeView> homeScreenData = db
		// what database to look at
				.view("retailDesignDoc/homeViewData").includeDocs(true)
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
					featured.add(new MinMetaData(homeView));
				} else {
					all.add(new MinMetaData(homeView));
				}
			}
			/*
			 * Coupons are always recommended and always included in all.
			 */
			if ("coupon".equals(type)) {
				recommended.add(new MinMetaData(homeView));
				all.add(new MinMetaData(homeView));
			}
			/*
			 * Lets handle products, if its recommended we add it to that list,
			 * otherwise just add it to the all list
			 */
			if ("product".equals(type)) {
				if (homeView.isRecommended()) {
					recommended.add(new MinMetaData(homeView));
				}
				all.add(new MinMetaData(homeView));
			}
		}

		// return a map with a key of featured, recommended, and all
		lists.put("featured", featured);
		lists.put("recommended", recommended);
		lists.put("all", all);

		Gson gson = new Gson();
		String json = gson.toJson(lists);
		return json;
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
	private Object getProductObjectById(String productId) {
		Object productObject = null;
		if (productId != null && !"".equals(productId)) {
			ProductDB product = db.find(ProductDB.class, productId);
			if (product != null && "product".equals(product.getType())) {
				Gson gson = new Gson();
				ArrayList<ColorOption> options = new ArrayList<ColorOption>();
				// 1. Query for all product from cloudant
				List<ProductDB> products = db.view("retailDesignDoc/products")
						.includeDocs(true).query(ProductDB.class);
				if (products != null) {
					for (ProductDB prod : products) {
						// If the product is a similar type but not the same
						// product...
						if (prod != null
								&& prod.getName().equals(product.getName())
								&& !prod.getId().equals(product.getId())) {
							// If we have more than one color option, we should
							// include the default color option as the
							// first option
							if (options.size() == 0) {
								options.add(new ColorOption(product));
							}
							options.add(new ColorOption(prod));
						}
					}
				}
				// 2. Loop over all products looking for products with a
				// different id but same name, add these to list
				// 3. Create productClient object from product object
				// 4. Add list of "optional"fields to product client object
				ProductClient pc = new ProductClient(product, gson.fromJson(
						getDepartmentById(product.getDepartment(), "en"),
						DepartmentClient.class));
				pc.setColorOptions(options);
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
	private String getProductById(String productId, String userLocale) {

		Gson gson = new Gson();
		return gson.toJson(getProductObjectById(productId));
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
	private String getStoreById(String storeId, String userLocale) {
		String storeJson = null;
		if (storeId != null && !"".equals(storeId)) {
			StoreDB store = db.find(StoreDB.class, storeId);
			if (store != null && "store".equals(store.getType())) {
				Gson gson = new Gson();
				storeJson = gson.toJson(new StoreClient(store));
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
	private String getCouponById(String couponId, String userLocale) {
		String json = null;
		if (couponId != null && !"".equals(couponId)) {
			CouponDB coupon = db.find(CouponDB.class, couponId);
			if (coupon != null && "coupon".equals(coupon.getType())) {
				Gson gson = new Gson();
				json = gson.toJson(new CouponClient(coupon));
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
	private String getDepartmentById(String departmentId, String userLocale) {
		String json = null;
		if (departmentId != null && !"".equals(departmentId)) {
			DepartmentDB department = db.find(DepartmentDB.class, departmentId);
			if (department != null && "department".equals(department.getType())) {
				Gson gson = new Gson();
				json = gson.toJson(new DepartmentClient(department));
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
	private int verifyUser(String username, String password) {
		// Sanity check for: null, empty, sql query, etc
		try {
			boolean sanityVerificationforUsername;
			sanityVerificationforUsername = sanityCheck(username);
			if (sanityVerificationforUsername != true) {
				throw new IllegalArgumentException();
			}
		} catch (Exception IllegalArgumentException) {
			LOGGER.log(Level.SEVERE, "Error");
		}

		// Sanity check for: null, empty, sql query, etc
		try {
			boolean sanityVerificationforPassword;
			sanityVerificationforPassword = sanityCheck(password);
			if (sanityVerificationforPassword != true) {
				throw new IllegalArgumentException();
			}
		} catch (Exception IllegalArgumentException) {
			LOGGER.log(Level.SEVERE, "Error");
		}

		int validUser = 0;
		List<UserDB> users = db.view("retailDesignDoc/userInfo")
				.includeDocs(true).query(UserDB.class);

		for (UserDB user : users) {
			if (user.getUsername() != null
					&& user.getUsername().equals(username)) {
				if (user.getPassword() != null
						&& user.getPassword().equals(password)) {
					validUser = 1;
					break;
				}
				validUser = 2;
				break;
			}
		}

		// DBCollection patientsCollection =
		// readyAppsDB.getCollection("patients");
		// BasicDBObject patientQueryUsername = new BasicDBObject();
		// patientQueryUsername.put("username", username);
		// BasicDBObject patientQuery = new BasicDBObject();
		// patientQuery.put("userID", username);
		// DBCursor cursorPatient =
		// patientsCollection.find(patientQueryUsername);

		// while (cursorPatient.hasNext()) {
		// DBObject document = cursorPatient.next();
		// String patientPassword = (String) document.get("password");
		// if (patientPassword.equals(password)) {
		// LOGGER.log(Level.INFO, "valid passcode");
		// validUser = true;
		// break;
		// }
		// }
		return validUser;
	}

	private static class UserList {
		String name;
		List<ProductClient> products;
	}

	/**
	 * Get all departments.
	 * 
	 * @return all departments in the database.
	 */
	private String getAllDepartments(String userLocale) {
		List<DepartmentDB> departments = db.view("retailDesignDoc/departments")
				.includeDocs(true).query(DepartmentDB.class);
		List<DepartmentClient> allDepartments = new ArrayList<DepartmentClient>();
		for (DepartmentDB department : departments) {
			DepartmentClient clientSideDepartment = new DepartmentClient(
					department);

			allDepartments.add(clientSideDepartment);
		}

		/*
		 * Rearranging departments so that we can demo beacons better.
		 */
		DepartmentClient mensBoots = allDepartments.remove(allDepartments
				.size() - 1);
		DepartmentClient winterSports = allDepartments.remove(3);
		DepartmentClient campingEssentials = allDepartments.remove(2);

		allDepartments.add(0, mensBoots);
		allDepartments.add(0, winterSports);
		allDepartments.add(0, campingEssentials);

		Gson gson = new Gson();

		return gson.toJson(allDepartments);
	}

	/**
	 * Get the lists associated with a given user
	 * 
	 * @param userId
	 * @param userLocale
	 * 
	 * @return defaultList - the list of products for user by ID.
	 */
	private String getDefaultList(String userId, String userLocale) {

		List<ListDB> userListObject = new ArrayList<ListDB>();

		UserDB user = db.find(UserDB.class, userId);
		ListDB items = db.find(ListDB.class, userId);

		String userListObjectJson = null;
		String productListObjectJson = null;

		List<String> userListIds;
		List<String> productListIds = null;
		List<Object> productObjects = null;
		Map<String, Object> listObjectWithProductObjects = new HashMap<String, Object>();
		List<UserList> userLists = new ArrayList<UserList>();

		if (user.getList() != null) {
			userListIds = user.getList();

			for (String userList : userListIds) {
				userListObject.add(db.find(ListDB.class, userList));

			}
			// insert product object in each object in items array
			for (ListDB listObject : userListObject) {
				List<String> prodIds = listObject.getItems();

				List<ProductClient> prods = new ArrayList<ProductClient>();

				for (String prodId : prodIds) {
					ProductClient p = (ProductClient) this
							.getProductObjectById(prodId);
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
		Object entryValue = null;
		boolean availability = true;
		// get the users store
		// query data
		List<UserDB> userData = db
		// what designdoc to look at
				.view("retailDesignDoc/userInfo").includeDocs(true)
				// actually runs the query
				.query(UserDB.class);
		// traverse the users to get the right one out
		String userStoreId = null;
		for (UserDB userDB : userData) {
			String userID = userDB.getId();
			// if its the userid that was passed
			if (userid.equals(userID)) {
				// get out their store
				userStoreId = userDB.getMystore();
				System.out.println("users storeid: " + userStoreId);
			}
		}

		// get the products info
		List<ProductDB> productData = db.view("retailDesignDoc/products")
				.includeDocs(true).query(ProductDB.class);
		// traverse the products to get the right one out
		for (ProductDB productDB : productData) {
			String productid = productDB.getId();
			// if its the productid that was passed
			if (productid.equals(productID)) {
				// compare the store ids to that of the users
				for (Object obj : productDB.getAvailability().values()) {
					// iterate over optionAvailability values
					Map<String, Double> optionAvailability = (Map<String, Double>) obj;
					for (Double value : optionAvailability.values()) {
						// see if extracted double value is zero (unavailable)
						if (value.equals(UNAVAILABLE)) {
							return false;
						}
					}
				}
			}
		}
		return availability;
	}

	/*
	 * Ensures that the data sent from the client is correct.
	 */
	private boolean sanityCheck(String argument) {
		// check for null, empty, sql query, etc
		try {
			if (argument == null) {
				throw new IllegalArgumentException("Argument cannot be null.");
			} else if (argument.equals("")) {
				throw new IllegalArgumentException("Argument cannot be empty.");
			} else if (argument.length() == 0) {
				throw new IllegalArgumentException("Argument cannot be empty.");
			} else if (argument.contains(" ")) {
				throw new IllegalArgumentException(
						"Argument cannot contain a space.");
			} else if (argument.toLowerCase().contains("show".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("update".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("db".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("insert".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("save".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("remove".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains("drop".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			} else if (argument.toLowerCase().contains(
					"collection".toLowerCase())) {
				throw new IllegalArgumentException(
						"Cannot perform database queries.");
			}
		} catch (Exception IllegalArgumentException) {
			LOGGER.log(Level.SEVERE,
					"Exception: " + IllegalArgumentException.getMessage());
		}

		return true;
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
		// cloudantConnector.connect();
		return CloudantConnector.cloudantConnector;
	}
};
