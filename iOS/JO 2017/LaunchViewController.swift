//
//  LaunchViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 22/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class LaunchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var tags : [String] = []
    var interestTag : [String] = []
    
    @IBOutlet weak var interets: UITableView!
    @IBOutlet weak var twitterAccount: UITextField!
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var titre1: UILabel!
    @IBOutlet weak var twit: UILabel!
    @IBOutlet weak var start: UIButton!
    
    @IBAction func go(_ sender: Any) {
        // /initUserTags
        let parameters : Parameters = [
            "_id" : UserDefaults.standard.value(forKey: "user_id")!,
            "tags": interestTag
        ]
        
        Alamofire.request("http://feeder.soc.catala.ovh/initUserTags", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                UserDefaults.standard.set("ok", forKey: "first")
                
            }
            
        }
        
        if let twitterName = twitterAccount.text{
            let twitterParam : Parameters = [
                "twitterName" : twitterName
            ]
            Alamofire.request("http://profiling.soc.catala.ovh/", method: .post, parameters: twitterParam, encoding: JSONEncoding.default).validate().responseJSON{
                response in
                if let r = response.result.value{
                    print(r)
                }
                
                print(response.debugDescription)
                
                switch response.result{
                case .success:
                    print("ok")
                case .failure:
                    print("error twitter")
                }
            }
        }
        
        
        self.performSegue(withIdentifier: "run", sender: self);

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "user_language") != "en"{
            
            
            translate(chaine: titre.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.titre.text = retour
            }
            translate(chaine: titre1.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.titre1.text = retour
            }
            translate(chaine: twit.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.twit.text = retour
            }
            translate(chaine: start.currentTitle!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                self.start.setTitle(retour, for: UIControlState.normal)
            }
        }

        self.interets.allowsMultipleSelection = true
        self.twitterAccount.delegate = self;

        //GET: /getTags
        Alamofire.request("http://feeder.soc.catala.ovh/getTags").validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                
                for tag in json{
                    self.tags.append(tag.1["_id"].stringValue)
                }
                DispatchQueue.main.async { self.interets.reloadData() }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interets.dequeueReusableCell(withIdentifier: "interet", for: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = self.tags[row]
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interets.cellForRow(at: indexPath)?.accessoryType = .checkmark
        interestTag.append((interets.cellForRow(at: indexPath)?.textLabel?.text)!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        interets.cellForRow(at: indexPath)?.accessoryType = .none
        var index = 0
        for i in interestTag{
            if i == interets.cellForRow(at: indexPath)?.textLabel?.text!{
                break
            }
            index+=1
        }
        interestTag.remove(at: index)
        
    }
}
