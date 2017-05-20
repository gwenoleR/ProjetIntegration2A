// Support TLS-specific URLs, when appropriate.
if (window.location.protocol == "https:") {
  var ws_scheme = "wss://";
} else {
  var ws_scheme = "ws://"
};

var phrase = "Welcome,you are near the Toto stadium! You can buy your country flag at the stadium's store";
let drapeauxPays = ["🇺🇸", "🇪🇸", "🇫🇷", "🇩🇪", "🇮🇹","🇷🇺", "🇧🇷"];
let model_id = ["en-es", "en-fr", "en-de", "en-it", "en-ru", "en-pt"];
var url = "http://soc.catala.ovh/v2/translate";

function request(oSelect) {	
	var xhr   = new XMLHttpRequest();
	xhr.onreadystatechange = function() {
		if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 0)) {
			readData(xhr.responseText);			
		} 
	};
	
	xhr.open("POST", url, true);
	xhr.setRequestHeader("Content-Type", "application/json", "Access-Control-Allow-Origin","true", "Host", "translator.soc.docker");
	xhr.send("IdEditor=" + value);
}

function readData(oData) {

	
}


























var retour;

var xhr = new XMLHttpRequest();
var url = "http://soc.catala.ovh/v2/translate";
xhr.open("POST", url, true);
xhr.setRequestHeader("Content-type", "application/json", "Host", "translator.soc.docker");
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        var json = JSON.parse(xhr.responseText);
        retour = xhr.responseText;    
    }
};
var data = JSON.stringify({"model_id":model_id[1],"source":"fr","target":"es", "text":phrase});
var resp = xhr.send(data);
console.log(retour);
//for(i = 0; i < 6; i++) {

  //var data = JSON.stringify({"model_id":model_id[i],"source":"fr","target":"es", "text":phrase});
  //xhr.send(data);
  //console.log(resp);
//}

for(i = 0; i < 7; i++) {
    $("#events-lang").append("<div class='panel panel-default'><div class='panel-heading'>" + $('<span/>').text(drapeauxPays[i]).html() + "</div><div class='panel-body'></div></div>");

}


