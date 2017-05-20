$(function(){

  $("#buttonSubmit").on("click", function(event){

    console.log("Clicked");
    
    var nom = $("#nomUser").val();
    var prenom = $("#prenomUser").val();
    var nationalite = $("#natio").val();
    var type = $("#type").val();

    console.log(nom);
    console.log(prenom);
    console.log(nationalite);
    console.log(type);

    $.ajax({
      type: "POST",
      url: "http://localhost:5000/addUsers",
      contentType: "application/json",      
      data: JSON.stringify({ "perso" :{ "nom":nom, "prenom" : prenom, "nationalite":nationalite, "type":type }}),

      success : function(){
        console.log("User send");        

        $("#nomUser").val("")
        $("#prenomUser").val("")

      },
      error : function(data){        

        console.log("An error occured : " + data.statusCode)

      }


    })


  })
})