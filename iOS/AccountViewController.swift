//
//  AccountViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 23/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var positions: UITextView!
    @IBOutlet weak var tags: UITextView!
    
    @IBOutlet weak var disconnect: UIButton!
    @IBOutlet weak var titre2: UILabel!
    @IBOutlet weak var titre1: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        let parameters: Parameters = [
            "_id" : UserDefaults.standard.string(forKey: "user_id")!
        ]
        
        Alamofire.request("http://tags.soc.catala.ovh/bestTagsOfUser", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                let json = JSON(response.result.value!)
                let tags = json["tags"].arrayValue
                var t = ""
                for tag in tags{
                    t += "\(tag["name"])\n"
                }
                self.tags.text = t
            case .failure:
                print("error tagUser")
            }
            
        }
        
        Alamofire.request("http://tags.soc.catala.ovh/bestPoiOfUser", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON{ response in
            switch response.result{
            case .success:
                let json = JSON(response.result.value!)
                let pois = json["poi"].arrayValue
                var p = ""
                for poi in pois{
                    p += "\(poi)\n"
                }
                self.positions.text = p
            case .failure:
                print("error poiUser")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "user_language") != "en"{
            
            translate(chaine: titre1.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.titre1.text = retour
            }
            translate(chaine: titre2.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.titre2.text = retour
            }
            translate(chaine: disconnect.currentTitle!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.disconnect.setTitle(retour, for: .normal)
            }
        }
        
        name.text = "\(UserDefaults.standard.string(forKey: "user_prenom")!)\n\(UserDefaults.standard.string(forKey: "user_nom")!)"
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deconnexion(_ sender: Any) {
        //TODO : Reset UserDefault
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_prenom")
        UserDefaults.standard.removeObject(forKey: "user_type")
        UserDefaults.standard.removeObject(forKey: "first")
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "Root_View")
        
    }
    
}
