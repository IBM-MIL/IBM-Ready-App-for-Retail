/**
 * SummitAdapter interfaces between the client and server. The clients can
 * invoke the adapter procedure and send the correct parameters. The adapter will
 * in turn make a call to the backend server. If the request is successful, the
 * adapter will return true, otherwise it will return false.
 */

/**
 * @class SummitAdapter-impl_.js
 * @description SummitAdapter implementation files which acts as a mediator between
 * the clients and the backend.
 */

/**
 * 
 * return the Singleton instance of the SummitConnector class
 */

var cloudantConnector = com.ibm.mil.summit.database.CloudantConnector.getInstance();
//Default locale is en
var defaultLocale = "en";


/**
 * @param locale
 * @return the "recommended" items for the home view
 */
function getHomeViewMetadata(locale) {
	if (!locale) {
		locale = defaultLocale;	
	}
	queryResult = cloudantConnector.getHomeViewMetaData(locale);	
		
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
 * @param productId
 * 				The product UUID 
 * @return The product object associated with the given UUID
 */
function getProductById(productId, locale) {
	if (!productId) {
		productId = null;	
	}
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getProductById(productId, locale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
  * @param couponId
 * 				The coupon UUID 
 * @return The coupon object associated with the given UUID
 */
function getCouponById(couponId, locale) {
	if (!couponId) {
		couponId = null;	
	}
	if (!locale)  {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getCouponById(couponId, locale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
 * @param storeId
 * 				The store UUID 
 * @return The store object associated with the given UUID
 */
function getStoreById(storeId, locale) {
	if (!storeId) {
		return {
			isSuccessful : false,
			result : "The store UUID can not be null, please provide one. ID passed in was: " + storeId
		};
	}
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getStoreById(storeId, locale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
 * @param departmentId
 * 				The department UUID  
 * @return The department object associated with the given UUID
 */
function getDepartmentById(departmentId, locale) {
	if (!departmentId) {
		departmentId = null;	
	}
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getDepartmentById(departmentId, userLocale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
 * @param userId
 * 				The user UUID 
 * @return The object for each list associated with the given UUID
 */
function getDefaultList(userId, locale) {
	if (!userId) {
		userId = null;
	}
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getDefaultList(userId, locale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}

/**
 * @param none
 * @return return all stores from the database
 */

function getAllStores(locale) {
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getAllStores(locale);
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The items were not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}


/**
 * Ensures the user is properly authenticated. Callback for protected adapter
 * procedures
 * 
 * @param headers
 * @param errorMessage
 * @return true if user is not authenticated
 */
function onAuthRequired(headers, errorMessage) {
	errorMessage = errorMessage ? errorMessage
			: "Authentication required to invoke this procedure!";

	return {
		authRequired : true,
		errorMessage : errorMessage
	};
}

/**
 * Exposed procedures to authenticate the user on initial login and subsequent
 * logins
 * 
 * @param username
 * @param password
 * @return true/false depending on the credentials provided
 */
function submitAuthentication(username, password) {
	var validUser = cloudantConnector.verifyUser(username, password);
	if (validUser == 1) {
		var userID = cloudantConnector.getUserID(username);

		var userIdentity = {
			userId : username,
			displayName : username,
			userId: userID
		};

		WL.Server.setActiveUser("SingleStepAuthRealm", userIdentity);
		return {
			isSuccessful : true,
			authRequired : false,
			result : userID
		};
	}
	if (validUser == 2) {
		return {
			onAuthRequired : onAuthRequired(null, "Invalid password"),
			isSuccessful : false,
		};
	}
	return {
		onAuthRequired : onAuthRequired(null, "Invalid username"),
		isSuccessful : false
	};

}

/**
 * Logs out the user due to inactivity or app termination
 */
function onLogout() {
	WL.Logger.info("Logged out");
	WL.Server.setActiveUser("SingleStepAuthRealm", null);
}

/**
 * Used to display the availability of a product
 * 
 * @param productId
 * @param userId
 * @return if the product is available, returns true. Otherwise returns false.
 */

function productIsAvailable(userid, productID, locale){
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.productIsAvailable(userid, productID, locale);	
	
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The requested information was not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};

}

/**
 * @param none
 * @return return all departments from the database
 */

function getAllDepartments(locale) {
	if (!locale) {
		locale = defaultLocale;
	}
	var queryResult = cloudantConnector.getAllDepartments(locale);
	var success = true;
	if (queryResult == null) {
		success = false;
		queryResult = "The items were not found in the database";
	}
	return {
		isSuccessful : success,
		result : queryResult
	};
}
