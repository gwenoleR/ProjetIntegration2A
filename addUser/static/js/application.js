$(function(){

  $("#buttonSubmit").on("click", function(event){

    console.log("Clicked");
    
    var nom = $("#nomUser").val();
    var prenom = $("#prenomUser").val();
    var nationalite = $("#natio").val();
    var type = $("#type").val();
    var language = $("#language").val()

    console.log(nom);
    console.log(prenom);
    console.log(nationalite);
    console.log(type);
    console.log(language);

    $.ajax({
      type: "POST",
      url: "http://addusers/addUsers",
      contentType: "application/json",      
      data: JSON.stringify({ "perso" :{ "nom":nom, "prenom" : prenom, "nationalite":nationalite,"language": language, "type":type }}),

      success : function(){
        console.log("User send");        

        $("#nomUser").val("")
        $("#prenomUser").val("")

      },
      error : function(data){        

        console.log("An error occured : " + data.statusCode)

      }


    })

    $.ajax({
    
      type: "POST",
      url: "http://addusers/getQrCode",
      contentType: "application/json",      
      data: JSON.stringify({"":""}),

      success : function(data){
        console.log("QrCode incomming !");  
        $("#qr").html(data)      

        

      },
      error : function(data){        

        console.log("An error occured : " + data.statusCode)

      }


    })


  })
})