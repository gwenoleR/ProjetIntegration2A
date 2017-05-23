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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        //GET: /getTags
        Alamofire.request("http://feeder.soc.catala.ovh/getTags").validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                
                for tag in json{
                    self.tags.append(tag.1["_id"].stringValue)
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tags"
 
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
        selectedTag = tags[indexPath.row]
        
        let parameters: Parameters = [
            "_id": UserDefaults.standard.string(forKey: "user_id")!,
            "tag": selectedTag,
            "weight": 5
            
        ]
        
        Alamofire.request("http://feeder.soc.catala.ovh/updateTagWeight", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in

            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            
        }
        
        self.performSegue(withIdentifier: "getPost", sender: indexPath);
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPost"{

            guard let postViewController = segue.destination as? FeedViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            postViewController.tag = selectedTag
            
        }
        
        
        
        
    }
    
}
