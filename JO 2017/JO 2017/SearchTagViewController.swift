//
//  SearchTagViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 20/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class SearchTagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tags : [String] = []
    var selectedTag : String = ""
    
    let headers: HTTPHeaders = [
        "Host": "feeder.soc.docker",
        ]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tags"
                
        //GET: /getTags
        Alamofire.request("http://soc.catala.ovh/getTags",headers:headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                //print(response.result.value ?? "")
                let json = JSON(response.result.value!)
                
                for tag in json{
                    print(tag)
                    self.tags.append(tag.1["_id"].stringValue)
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "simple", for: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = self.tags[row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tags[indexPath.row])
        selectedTag = tags[indexPath.row]
        
        let parameters: Parameters = [
            "_id": UserDefaults.standard.value(forKey: "user_id")!,
            "tag": selectedTag,
            "weight": 10
            
        ]
        Alamofire.request("http://soc.catala.ovh/updateTagWeight", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers).validate().responseJSON{ response in
            switch response.result {
            case .success:
                print("Success")
                //print(UserDefaults.standard.value(forKey: "tags")!)
                
                
            case .failure(let error):
                print("error : \(error)")
            }
        }
        
        self.performSegue(withIdentifier: "getPost", sender: indexPath);
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPost"{
            
            print(selectedTag)
            
            guard let postViewController = segue.destination as? FeedViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            postViewController.tag = selectedTag
            
        }
        
        
        
        
    }
    
}
