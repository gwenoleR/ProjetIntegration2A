//
//  LaunchViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 22/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class LaunchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tags : [String] = []
    var interestTag : [String] = []
    
    @IBOutlet weak var interets: UITableView!
    @IBOutlet weak var twitterAccount: UITextField!
    
    @IBAction func go(_ sender: Any) {
        // /initUserTags
        let parameters : Parameters = [
            "_id" : UserDefaults.standard.value(forKey: "user_id")!,
            "tags": interestTag
        ]
        
        Alamofire.request("http://feeder.soc.catala.ovh/initUserTags", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in
            
            debugPrint("All Response Info: \(response)")
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                UserDefaults.standard.set("ok", forKey: "first")
                self.performSegue(withIdentifier: "run", sender: self);
            }
            
        }
        
        //UserDefaults.standard.set("ok", forKey: "first")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interets.allowsMultipleSelection = true

        
        let headers: HTTPHeaders = [
            "Host": "feeder.soc.docker",
            ]
        
        //GET: /getTags
        Alamofire.request("http://feeder.soc.catala.ovh/getTags").validate().responseJSON { response in
            switch response.result {
            case .success:
                //print(response.result.value ?? "")
                let json = JSON(response.result.value!)
                
                for tag in json{
                    print(tag)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
