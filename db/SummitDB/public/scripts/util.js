//utilities
function createXHR(){
	if(typeof XMLHttpRequest != 'undefined'){
		return new XMLHttpRequest();
	}else{
		try{
			return new ActiveXObject('Msxml2.XMLHTTP');
		}catch(e){
			try{
				return new ActiveXObject('Microsoft.XMLHTTP');
			}catch(e){}
		}
	}
	return null;
}
function xhrGet(url, callback, errback){
	var xhr = new createXHR();
	xhr.open("GET", url, true);
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if(xhr.status == 200){
				callback(parseJson(xhr.responseText));
			}else{
				errback('service not available');
			}
		}
	};
	
	xhr.timeout = 100000;
	xhr.ontimeout = errback;
	xhr.send();
}
function xhrPut(url, data, callback, errback){
	var xhr = new createXHR();
	xhr.open("PUT", url, true);
	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if(xhr.status == 200){
				callback();
			}else{
				errback('service not available');
			}
		}
	};
	xhr.timeout = 100000;
	xhr.ontimeout = errback;
	xhr.send(objectToQuery(data));
}

function xhrAttach(url, data, callback, errback)
{
	var xhr = new createXHR();
	xhr.open("POST", url, true);
	//xhr.setRequestHeader("Content-type", "multipart/form-data");
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if(xhr.status == 200){
				callback(parseJson(xhr.responseText));
			}else{
				errback('service not available');
			}
		}
	};
	xhr.timeout = 1000000;
	xhr.ontimeout = errback;
	xhr.send(data);
}

function xhrPost(url, data, callback, errback){
	var xhr = new createXHR();
	xhr.open("POST", url, true);
	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if(xhr.status == 200){
				callback(parseJson(xhr.responseText));
			}else{
				errback('service not available');
			}
		}
	};
	xhr.timeout = 100000;
	xhr.ontimeout = errback;
	xhr.send(objectToQuery(data));
}

function xhrDelete(url, callback, errback){	
	var xhr = new createXHR();
	xhr.open("DELETE", url, true);
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if(xhr.status == 200){
				callback();
			}else{
				errback('service not available');
			}
		}
	};
	xhr.timeout = 100000;
	xhr.ontimeout = errback;
	xhr.send();
}

function parseJson(str){
	return window.JSON ? JSON.parse(str) : eval('(' + str + ')');
}

function objectToQuery(map){
	var enc = encodeURIComponent, pairs = [];
	for(var name in map){
		var value = map[name];
		var assign = enc(name) + "=";
		if(value && (value instanceof Array || typeof value == 'array')){
			for(var i = 0, len = value.length; i < len; ++i){
				pairs.push(assign + enc(value[i]));
			}
		}else{
			pairs.push(assign + enc(value));
		}
	}
	return pairs.join("&");
}

