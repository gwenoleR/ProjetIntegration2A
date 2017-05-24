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
    let id : String
    
    init(titre: String, content: String, tags: [String], id : String) {
        self.Titre = titre
        self.Content = content
        self.tags = tags
        self.id = id
    }
    
    func isEqual(_ at:Feed) -> Bool{
        if(self.id == at.id) {return true}
        return false
    }
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feeds : [Feed] = []
    
    var tag : String = ""
    
    var selectedFeed : Feed!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getPost()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getPost(){
        print("getPostCalled tads : \(tag)")
        
        var url = ""
        if tag == "" {
            url = "http://tags.soc.catala.ovh/getInterestPosts"
            
            let param : Parameters = [
                "_id" : UserDefaults.standard.string(forKey: "user_id")!
            ]
        
            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).validate().responseJSON{ response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    if let result = response.result.value {
                        
                        let json = JSON(result)
                        
                        for f in json{
                            
                            let content = f.1["content"].stringValue
                            let title = f.1["title"].stringValue
                            let tagsArray = f.1["tags"].arrayValue
                            let _id = f.1["_id"].stringValue
                            
                            var tags:[String] = []
                            for t in tagsArray{
                                tags.append(t.stringValue)
                            }
                            
                            let feed = Feed(titre: title, content: content, tags: tags, id: _id)
                            
                            var add = true
                            for f in self.feeds{
                                if feed.isEqual(f){
                                    add = false
                                    break
                                }
                            }
                            if add {
                                self.feeds.append(feed)
                            }
                        }
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                case .failure(let error):
                    print(error)
                }

                
            }
        
        }
        else{
            url = "http://feeder.soc.catala.ovh/getPostAbout/\(tag)"
            
            Alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    if let result = response.result.value {
                        
                        let json = JSON(result)
                        
                        for f in json{
                            
                            let content = f.1["content"].stringValue
                            let title = f.1["title"].stringValue
                            let tagsArray = f.1["tags"].arrayValue
                            let _id = f.1["_id"].stringValue
                            
                            var tags:[String] = []
                            for t in tagsArray{
                                tags.append(t.stringValue)
                            }
                            
                            let feed = Feed(titre: title, content: content, tags: tags, id: _id)
                            
                            var add = true
                            for f in self.feeds{
                                if feed.isEqual(f){
                                    add = false
                                    break
                                }
                            }
                            if add {
                                self.feeds.append(feed)
                            }
                        }
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPost()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "user_language") != "en"{
            
            if let t = self.title{
                translate(chaine: t, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                    self.title = retour
                }
            }
        }
        
        self.tableView.addSubview(self.refreshControl)
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
        selectedFeed = feeds[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: indexPath);
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            
            guard let detailViewController = segue.destination as? DetailFeedViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            detailViewController.feed = selectedFeed
            
        }
        
    }
    
    
}
