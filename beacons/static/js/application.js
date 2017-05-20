


// Support TLS-specific URLs, when appropriate.
if (window.location.protocol == "https:") {
  var ws_scheme = "wss://";
} else {
  var ws_scheme = "ws://"
};



var phrase = "Welcome,you are near the Toto stadium! You can buy your country flag at the stadium's store";
let drapeauxPays = ["🇺🇸", "🇪🇸", "🇫🇷", "🇩🇪", "🇮🇹", "🇷🇺", "🇧🇷"];
let model_id = ["en-es", "en-fr", "en-de", "en-it", "en-ru", "en-pt"];
var url = "http://soc.catala.ovh/v2/translate";

function requestT() {
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function () {
    if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 0)) {
      
      readData(xhr.responseText);
    }
  };
  var data = JSON.stringify({ "model_id": model_id[1], "source": "fr", "target": "es", "text": phrase });
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-Type", "application/json", "Access-Control-Allow-Origin", "true", "Host", "translator.soc.docker");
  xhr.send(data);
}

function readData(oData) {

  console.log(oData);
}

requestT();

for (i = 0; i < 7; i++) {
  $("#events-lang").append("<div class='panel panel-default'><div class='panel-heading'>" + $('<span/>').text(drapeauxPays[i]).html() + "</div><div class='panel-body'></div></div>");

}


