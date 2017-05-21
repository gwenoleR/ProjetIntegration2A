Serveur de gestion des données GPS.

Routes : 

    /getAllPoi
    Usage : 
        METHOD = GET
        RETURN = { "poi" : [ { POI_1 }, { POI_2 } , ... ] }  , 200 OK
        Renvoie un document JSON contenant l'ensemble des POI

    /userPoi
    Usage :
        METHOD = POST
        HEADER = "Content-Type": "application/json"
        REQUEST DATA = { "_id" : <un user_id valide> , "poi_id : <un poi_id valide> , "inOut" : <une instruction d'entree ou de sortie (in/out)> }
        RETURN = 
                 in/out   "La demande d'entree/de sortie bien prise en compte"      200 OK
                 in/out   "Le poi n'existe pas"                                     400 BAD REQUEST
                 in/out   "L'utilisateur n'existe pas"                              400 BAD REQUEST
                 in/out   "Mauvais formatage du JSON"                               400 BAD REQUEST
                 in       "L'utilisateur est deja dans la zone"                     400 BAD REQUEST
                 out      "L'utilisateur n'etait pas dans la zone"                  400 BAD REQUEST
        Permet l'entree ou la sortie d'un utilisateur dans une zone, si un utilisateur entre dans une zone et qu'il etait present dans une autre,
        il est supprimé de l'ancienne.
    
    /getUsersInPoi
    Usage : 
        METHOD = POST
        HEADER = "Content-Type": "application/json"
        REQUEST DATA = { "poi_id : <un poi_id valide> }
        RETURN = 
                          { "users" : [ USER_ID_1 , USER_ID_2 , ... ] }             200 OK
                          "Le poi n'existe pas"                                     400 BAD REQUEST
                          "Mauvais formatage du JSON"                               400 BAD REQUEST