//
//  FeedViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 16/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class Feed{
    let Titre: String
    let Content: String
    let tags : [String]
    
    
    
    init(titre: String, content: String, tags: [String]) {
        self.Titre = titre
        self.Content = content
        self.tags = tags
    }
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feeds : [Feed] = []
    var json : JSON = JSON.null
    
    var tag : String = ""
    
    var selectedFeed : Feed!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headers: HTTPHeaders = [
            "Host": "feeder.soc.docker",
            ]
        
        var url = ""
        if tag == "" {
            url = "http://soc.catala.ovh/getLast10Post"
        }
        else{
            url = "http://soc.catala.ovh/getPostAbout/\(tag)"
        }
        
        //GET: /GetLast10Post
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let result = response.result.value {
                    
                    self.json = JSON(result)
                    
                    for f in self.json{
                        
                        print(f)
                        
                        let content = f.1["content"].stringValue
                        let title = f.1["title"].stringValue
                        let tagsArray = f.1["tags"].arrayValue
                        
                        var tags:[String] = []
                        for t in tagsArray{
                            tags.append(t.stringValue)
                        }
                        
                        let feed = Feed(titre: title, content: content, tags: tags)
                        self.feeds.append(feed)
                        
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
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
        return self.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simple", for: indexPath)
        
        let row = indexPath.row
        
        cell.textLabel?.text = self.feeds[row].Titre
        cell.detailTextLabel?.text = self.feeds[row].Content
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(feeds[indexPath.row])
        selectedFeed = feeds[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: indexPath);
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            
            print(selectedFeed)
            
            guard let detailViewController = segue.destination as? DetailFeedViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            detailViewController.feed = selectedFeed
            
        }
        
        
        
        
    }
}
