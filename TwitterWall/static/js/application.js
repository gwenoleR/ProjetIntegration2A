// Support TLS-specific URLs, when appropriate.
if (window.location.protocol == "https:") {
  var ws_scheme = "wss://";
} else {
  var ws_scheme = "ws://"
};


var inbox = new ReconnectingWebSocket(ws_scheme + location.host + "/receive");
var outbox = new ReconnectingWebSocket(ws_scheme + location.host + "/submit");

inbox.onmessage = function(message) {
  var data = JSON.parse(message.data)
  var imageOrnot = "";
  var sautDeLigne = "";
  console.log(data.image);
  if(data.image == ""){
    console.log("image vide");
    imageOrnot = "";
    sautDeLigne = "";
  }else {
    console.log("image pas vide");
    imageOrnot = ":medium";
    sautDeLigne = "<br>";
  }
  $("#twitter-wall").append("<div class='panel panel-default'><div class='panel-heading'>" + $('<span/>').text(data.name).html()+ $('<span/>').text(" @").html() + $('<span/>').text(data.screen_name).html() + "</div><div class='panel-body'>" + $('<span/>').text(data.text).html()+sautDeLigne+ "<img  src="+ data.image+ imageOrnot +">" + "</div></div>");
  
  $("#twitter-wall").stop().animate({
    scrollTop: $('#twitter-wall')[0].scrollHeight
  }, 800);
};

inbox.onclose = function(){
    console.log('inbox closed');
    this.inbox = new WebSocket(inbox.url);

};

outbox.onclose = function(){
    console.log('outbox closed');
    this.outbox = new WebSocket(outbox.url);
};

$("#input-form").on("submit", function(event) {
  event.preventDefault();
  var handle = $("#input-handle")[0].value;
  var text   = $("#input-text")[0].value;
  outbox.send(JSON.stringify({ name: name,screen_name: screen_name, text: text, image: image }));
  $("#input-text")[0].value = "";
});
