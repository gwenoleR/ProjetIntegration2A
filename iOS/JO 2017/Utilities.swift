//
//  Utilities.swift
//  JO 2017
//
//  Created by Gwenolé on 16/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

// MARK: Helper Extensions
extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func translate(chaine:String, to:String,completion:@escaping (String) -> Void){
        
        let parameters : Parameters = [
            "model_id" : "en-\(to)",
            "source" : "en",
            "target" : "\(to)",
            "text": ["\(chaine)"]
        ]
        var retour = ""
        
        Alamofire.request("http://translator.soc.catala.ovh/v2/translate", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON{ response in
            
            switch(response.result){
            case .success:
               
                if let resp = response.result.value{
                        retour = resp as! String
                        completion(retour)
                }
            case .failure:
                print("error trad")
                retour = chaine
                completion(retour)
                
            }
        }
        
    }
}

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        setRegion(region, animated: true)
    }
}
