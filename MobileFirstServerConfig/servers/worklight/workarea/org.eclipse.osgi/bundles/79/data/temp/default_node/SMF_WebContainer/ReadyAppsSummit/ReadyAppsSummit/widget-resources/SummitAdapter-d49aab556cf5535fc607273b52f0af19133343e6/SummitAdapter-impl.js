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
 * return the Singleton instance of the SummitConnector class
 */

var summitConnector = com.ibm.mil.summit.database.CloudantConnector
		.getInstance();




function putData(allData) {
	
	var wrappedData = {
			docs:[allData]
	};
	
	var input = {
		method : 'post',
		returnedContentType : 'json',
		path : '/products/_bulk_docs',
		body : {
			contentType: 'application/json',
			content: JSON.stringify(wrappedData)
		}
	};
	return WL.Server.invokeHttp(input);
}

function getLandingPageData(data) {
	path = getPath(data);

	var landingData = {
		method : 'get',
		returnedContentType : 'json',
		path : path
	};

	return WL.Server.invokeHttp(landingData);
}

function test() {
	return {
		isSuccessful : true,
		result : {
			"_id": "563c24bf07d48b9aa0b8b51525fc0e5c",
			  "_rev": "3-68bff5d35546e384c95f3f73a2c797cc",
			  "name": "Product 1",
			  "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
			  "sizes": [
			    "S",
			    "M",
			    "L",
			    "XL"
			  ],
			  "price": 19.99,
			  "type": "product"
		}
	};
}