$(window).on('load', function () {
	showLoader('hide');
});

$(document).ready(function () {
	window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {
		window.platformReady = true;
	});
});

function getUrlVars() {
	var vars = {};
	var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
		var convert = convertType(decodeURI(value));
		vars[key] = convert;
	});
	if(vars.hasOwnProperty('clientId')){
		vars["clientId"] = vars.clientId;
	}
	if(vars.hasOwnProperty('env_code')){
		vars["env_code"] = vars.env_code.toLowerCase();
	}
	return vars;
}

var convertType = function (value) {
	var values = {
			undefined: undefined,
			null: null,
			true: true,
			false: false
		},
		isNumber = !isNaN(+(value));
	return isNumber && +(value) || !(value in values) && value || values[value];
};

function isValidJSON(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		console.log("JSON Parsing error [" + str + "]\n" + e);
		return false;
	}
	return true;
}

function now() {
	return new Date(new Date().toString().split('GMT')[0] + ' UTC').toISOString().split('.')[0];
}

function URLBuilder(baseURL, docvars, hasUser, hasMember) {
	let url = new URL(baseURL);
	let params = '';
	params = url.searchParams;
	params.append("userName", docvars.userName);
	params.append("departmentName", docvars.departmentName);
	params.append("hasUser", hasUser);
	params.append("hasMember", hasMember);
	params.append("role", docvars.loggedInRole.toLowerCase());
	if (docvars.membershipId != "null") {
		params.append("membershipId", docvars.membershipId);
	}
	console.log(url.toString());
	return url.toString();
}

function disable(id) {
	var comp = document.querySelectorAll("[id^=" + id + "]");
	for (var i = 0; i < comp.length; i++) {
		comp[i].disabled = true;
	}
	document.getElementById(id).disabled = true;
	$('#' + id).addClass('disable');
}

function showComponent(value, status) {
	if (status) {
		$('input[type="radio"][value="' + value + '"]').prop('disabled', false);
	} else {
		$('input[type="radio"][value="' + value + '"]').prop('disabled', true);
	}
}

function enable(id) {
	document.addEventListener("DOMContentLoaded", function (event) {
		document.getElementById(id).disabled = false;
		$('#' + id).removeClass('disable');
	});
}

function showLoader(loader) {
	if (loader == 'show') {
		$(".loader").show();
		$("#builder").addClass('hide');
	} else {
		$(".loader").hide();
		$("#builder").removeClass('hide');
	}
}

function fetchRequest(form, URL, userObject, handlerName) {
	showLoader('show');
	fetchAPI(URL, JSON.stringify(userObject), handlerName).then(response => {
		showLoader('hide');
		if (!response.hasOwnProperty('errorCode')) {
			form.emit('submitDone', 'Success')
		} else {
			form.emit('submitError', response.message);
		}
	}).catch(function (error) {
		console.log("error fetch", error);
	});
}

var fetchAPI = async function (url, formdata, handlerName) {
	var platformReady = true;
	var options = {
		method: 'POST',
		body: formdata,
		redirect: 'follow',
		headers: new Headers({
			'content-type': 'application/json',
			'clientid': clientId
		})
	};
	let response = await fetch(url, options)
	console.log('response', JSON.stringify(response));
	if (response.ok) {
		let json = await response.json();
		console.log('response body', json, "flutterPlatformReady ", platformReady);
		try {
			if (platformReady) {
				window.flutter_inappwebview.callHandler(handlerName, response.status, json);
			}
		} catch (e) {
			console.log("flutter_inappwebview error");
		}
		return json;
	} else {
		let json = await response.json();
		console.log('error', json.message, json.errorCode);
		try {
			if (platformReady) {
				window.flutter_inappwebview.callHandler(handlerName, response.status, json);
			}
		} catch (e) {
			console.log("flutter_inappwebview error");
		}
		return json;
	}
}

function getFormInfo(URL, data) {
	var param = {};
	param["departmentName"] = data.departmentName;
	param["role"] = data.loggedInRole.toLowerCase();
	
	if (data.userName && data.userName != "null") {
		param["userName"] = data.userName;
	}
	if (data.membershipId && data.membershipId != "null"){
		param["membershipId"] = data.membershipId;
	}
	var formObj = {};
	$.ajax({
		url: URL,
		type: "GET",
		data: param,
		async: false,
		success: function (result) {
			console.log(result);
			result["formDefinition"] = JSON.parse(result.formDefinition);
			if (data.page.toLowerCase() == "adduser" || data.page.toLowerCase() == "signup" ){
				result["formData"] = {"hasUser":false, "hasMember":false};
			}else {
				result["formData"] = JSON.parse(result.formData);
			}
			var schemeId = null;
			if(result.formData.hasOwnProperty('schemeId')){
				schemeId = result.formData.schemeId;
			}
			membershipCard(result.schemeDefinition, data, schemeId);
			formObj = result;
		},
		beforeSend: function (request) {
			request.setRequestHeader("clientid", clientId);
			showLoader('show');
		},
		complete: function () {
			showLoader('hide');
		},
		error: function (textStatus) {
			console.log(textStatus);
			alert(textStatus.responseJSON.message);
			formObj = textStatus.responseJSON;
		}
	});
	return formObj;
}

function getCountries(alphaCode) {
	var callingCode = '';
	var url = "https://qa-memberly.github.io/qa/sites/assets/dist/countries.json";
	var options = {
		method: 'GET'
	};
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("GET", url, false);
	xmlHttp.send(null);
	var code = JSON.parse(xmlHttp.responseText);
	for (var i in code) {
		if (code[i].alphaCode == alphaCode) {
			callingCode = code[i].callingCode;
		}
	}
	return callingCode;
}

var payee = async function payButton(data, RegistrationFees) {
	console.log('payButton', data);
	var description;
	var platformReady = true;
	if (data.renewalEligible) {
		RegistrationFees = 0;
		description = "Membership Renewal Fee for " + data.userFullName;
	} else {
		description = "Membership Fee for " + data.userFullName;
	}
	var json = {
		"totalAmount": data.fees + RegistrationFees,
		"payeePhoneNumber": data.countryCodeValueHome + data.homeNumber,
		"payeeName": data.userFullName,
		"payeeEmail": data.emailId,
		"paymentDescription": description
	};
	console.log(json, data.isMember);
	console.log('flutterPlatformReady', window.platformReady);
	//alert('window flutterPlatformReady', platformReady);
	let transaction = null;
	if (platformReady) {
		await window.flutter_inappwebview.callHandler('handlerPayWithArgs', json).then(await
			function (data) {
				console.log("handlerPayResponseWithArgs" + JSON.stringify(data));
				if (Array.isArray(data.response)) {
					data["response"] = data.response[0];
				}
				var receiptNo = null;
				var paymentMode = null;
				var transactionStatus = null;
				if (data.response) {
					receiptNo = data.response.transactionId;
					paymentMode = data.response.paymentMode;
					transactionStatus = data.response.transactionStatus;
				}
				if (!data.response && !data.isCancelled && getUrlVars().loggedInRole == 'user') {
					paymentMode = 'CASH';
					transactionStatus = 'success';
				}

				if (data.receiptNumber) {
					receiptNo = data.receiptNumber;
				}

				transaction = {
					"receiptNo": receiptNo,
					"paymentMode": paymentMode,
					"paymentStatus": transactionStatus
				};

			});
		data["receiptNo"] = transaction.receiptNo;
		data["paymentMode"] = transaction.paymentMode;
		data["paymentStatus"] = transaction.paymentStatus;
		if (data.paymentStatus === 'success') {
			data["membershipStatus"] = 'Pending Approval';
			data["memberStatus"] = 'Pending Approval';
		}
		return data;
	} else {
		transaction = {
			"receiptNo": "12345",
			"paymentMode": "CASH",
			"paymentStatus": "success"
		};
		data["receiptNo"] = transaction.receiptNo;
		data["paymentMode"] = transaction.paymentMode;
		data["paymentStatus"] = transaction.paymentStatus;
		if (data.paymentStatus === 'success') {
			data["membershipStatus"] = 'Pending Approval';
			data["memberStatus"] = 'Pending Approval';
		}
		return data;
	}
}

function membershipCard(scheme, data, selected) {
	let card = "<div id='scheme-card' class='container-fluid'>";
	card += "<div class='u-pos--rel c-banner-container' id='banner'>";
	
	card += "<div class='u-p--16 text-white text-bold c-banner-container__content'>";
	card += "<img alt='Plus Logo' class='u-columns u-two u-m-b--10 ' effect='blur' src='../assets/brand/plus-logo.png''>";
	card += "<div class='u-text--bold text-large bg-black'>Unlimited benefits with "+ data.departmentName +" Member+";
	card += "</div>";
	card += "</div>";
	card += "</div>";
	/*card += "<div class='row' style='margin-left: 25px;'>";
	card += "<div class='col-xs-12 text-md-right lead'>";
	card += "<a id='left-button' class='btn btn-outline-secondary prev' title='go back'><i class='fa fa-angle-left'></i></a>";
	card += "<a id='right-button' class='btn btn-outline-secondary next' title='more'><i class='fa fa-angle-right'></i></a>";
	card += "</div>";
	card += "</div>"; */
	card += "<div id='scheme' class='d-flex flex-row flex-nowrap overflow-auto'>";
	card += "<div class='pricing row flex-column flex-md-row'>";
	card += "<div class='u-p-v--10 text-center c-card-slider' id='plans' style='overflow: visible;'>";
	card += "<div class='u-d-flex u-p-h--8'>";
	scheme.forEach(function (data) {
		if (data.schemeName == "Basic") {
			$('#'+data.schemeId).addClass('price-filter-active');
		}
		card += "<div class='col-auto mb-3' style='display: flex;'>";
		card += "<div class='card card-pricing text-center px-3 mb-4 u-m-h--8' style='width: 8rem;' aria-haspopup='true' id=" + data.schemeId + ">";
		if(data.schemeBenefitsHighlights){
			card += "<div class='card-ribbon'>";
			card += "<span>"+data.schemeBenefitsHighlights+"</span>";
			card += "</div>";
		}
		card += "<span class='mx-auto px-4 py-1 rounded-bottom bg-primary-card text-white shadow-sm text-zeta u-text--bold'>" + data.schemeName + "</span>";
		card += "<div class='u-text--uppercase u-p-t--20 u-p-b--15 u-border-bottom--paleGrey u-text--bold text-mt u-pos--rel'>" + data.schemeBilingType + "</div>";
		card += "<div class='plan-details u-d-flex u-d-flex--center u-border-bottom--paleGrey'>";
		card += "<div class='u-p-b--20 u-p-t--8'>";
		card += "<div class='text-gre u-text--striked text-epsilon u-m-r--4 il-f'>";
		card += "<div class='text-currency-symbol'>" + data.schemeCurrencySymbol + "</div>";
		card += "<div class=''>" + data.schemeActualPrice + "</div>";
		card += "</div>";
		card += "<div class='card_container'>";
		card += "<sup class='text-currency-symbol'>" + data.schemeCurrencySymbol + "</sup><span class='text-delta text-currency text-center u-text--bold u-align--vm cardBlock'>" + data.schemeActivePrice + "</span>";
		//card += "<span class='text-theta text-gre u-align--vtt cardBlock'>/ " + data.schemeDuration + "</span>";
		card += "</div>";
		card += "<div class='text-green u-m-t--4 text-zeta u-text--bold'>" + data.schemeOfferEnforced + "";
		card += "</div>";
		card += "</div>";
		card += "</div>";
		card += "<div class='card-footer-member'>";
			getContent(data.schemeContent).forEach(function (content) {
			content = content.trimStart();
			if(!content.startsWith("#")){
				card += "<div class='u-p-v--12 text-gre text-zeta-lf'><img class='text-info' src='../assets/brand/mark.svg'> "+content+"</div>";
			}else{
				card += "<div class='u-p-v--12 text-gre text-zeta-lf ct-st'><img class='text-info' src='../assets/brand/x-mark.svg'> "+content.replace("#","")+"</div>";
			}	
			});
		card += "<a href='#' class='btn read'><i id='card-icon' class='fa fa-angle-right'></i></a>";
		card += "</div>";
		card += "</div>";
		card += "</div>";
	});
	card += "</div>";
	card += "</div>";
	card += "</div>";
	card += "</div>";

	card += "</div>";

	// Append the new article card to the article section div
	if(data.page != "signup"){
		$("#membership-card").append(card);
		cardActivation();
		if(selected){
			$('#'+selected).addClass('price-filter-active');
		}
	}
}

function cardActivation() {
	$('.card-pricing').click(function () {
	
		$('.price-filter-active').not(this).removeClass('price-filter-active').removeClass('fa-angle-right');
		$(this).addClass('price-filter-active');
		$(this).find('#card-icon').addClass('fa-check');
		
		var id = $(this).attr('id');
		console.log(id);
		/*  $('.price-filter-active').not(this).removeClass('price-filter-active');
			$(this).toggleClass('price-filter-active');
			$this = $(this);
			if (!$this.hasClass('active')) {
			$('.card-pricing').removeClass('active');
			$(this).attr('id').addClass('active');
			var id = $(this).attr('id');
			console.log(id);
			} */
	})
	var view = $("#scheme");
	var sliderLimit = 120;

	$("#right-button").click(function () {
		view.animate({
			scrollLeft: "+=" + sliderLimit
		}, {
			duration: 400
		});
	});

	$("#left-button").click(function () {
		view.animate({
			scrollLeft: "-=" + sliderLimit
		}, {
			duration: 400
		});
	});
}

(function () {

	var scrollHandle = 0,
		scrollStep = 5,
		parent = $(window);

	//Start the scrolling process
	$(".panner").on("mouseenter", function () {
		var data = $(this).data('scrollModifier'),
			direction = parseInt(data, 10);

		$(this).addClass('active');

		startScrolling(direction, scrollStep);
	});

	//Kill the scrolling
	$(".panner").on("mouseleave", function () {
		stopScrolling();
		$(this).removeClass('active');
	});

	//Actual handling of the scrolling
	function startScrolling(modifier, step) {
		if (scrollHandle === 0) {
			scrollHandle = setInterval(function () {
				var newOffset = parent.scrollLeft() + (scrollStep * modifier);

				parent.scrollLeft(newOffset);
			}, 10);
		}
	}

	function stopScrolling() {
		clearInterval(scrollHandle);
		scrollHandle = 0;
	}

}());

function getParentForm(info) {
	var def = info.formDefinition;
	return def;
}

function getScheme(id, scheme) {
	return scheme.filter(function(data){return (data['schemeId'] == id);})[0];
}

function getSymbol(name){
    let symbol = {
      'USD': '$', // US Dollar
      'EUR': '€', // Euro
      'CRC': '₡', // Costa Rican Colón
      'GBP': '£', // British Pound Sterling
      'ILS': '₪', // Israeli New Sheqel
      'INR': '₹', // Indian Rupee
      'JPY': '¥', // Japanese Yen
      'KRW': '₩', // South Korean Won
      'NGN': '₦', // Nigerian Naira
      'PHP': '₱', // Philippine Peso
      'PLN': 'zł', // Polish Zloty
      'PYG': '₲', // Paraguayan Guarani
      'THB': '฿', // Thai Baht
      'UAH': '₴', // Ukrainian Hryvnia
      'VND': '₫', // Vietnamese Dong
    }

    if(symbol[name] !== undefined) {
        return symbol[name];
    }
}

function getContent(data){
	var array = data.split(',');
	console.log(array);
	return array;
}

function membershipFees(data){
	console.log(data);
	var fees = "";
	if(data.schemeBilingType == "MONTHLY"){
		fees = "1 Month - " + data.schemeCurrencySymbol + " "+ data.schemeActivePrice;
	}else if(data.schemeBilingType == "QUARTERLY"){
		fees = "3 Months - " + data.schemeCurrencySymbol + " "+ data.schemeActivePrice;
	}else if(data.schemeBilingType == "HALFYEARLY"){
		fees = "6 Months - " + data.schemeCurrencySymbol + " "+ data.schemeActivePrice;
	}else if(data.schemeBilingType == "YEARLY"){
		fees = "1 year - " + data.schemeCurrencySymbol + " "+ data.schemeActivePrice;
	}
	return fees;
}

