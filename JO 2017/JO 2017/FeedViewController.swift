//
//  FeedViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 16/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit

class Feed{
    let Titre: String
    let Content: String
    
    
    
    init(titre: String, content: String) {
        self.Titre = titre
        self.Content = content
    }
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var feeds : [Feed] = []
    var json : JSON = JSON.null
    
    var selectedFeed : Feed!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let requestURL: NSURL = NSURL(string: "http://172.30.0.221:3000/getLast10Post")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    self.json = try JSON(data: data!)
                    
                    for f in self.json{
                        
                        let content = f.1["content"].stringValue
                        let title = f.1["title"].stringValue
                        
                        let feed = Feed(titre: title, content: content)
                        
                        self.feeds.append(feed)
                    }
                    
                }
                catch{
                    print("Error json")
                }

                DispatchQueue.main.async { self.tableView.reloadData() }
                
            }
        }
        
        task.resume()
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
        else{
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
        
        
    }
}
