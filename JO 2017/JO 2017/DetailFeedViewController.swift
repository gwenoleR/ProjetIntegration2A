//
//  DetailFeedViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 17/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit

class DetailFeedViewController: UIViewController {
    
    var feed : Feed!

    
    @IBOutlet weak var t: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var tags: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        t.text = feed.Titre
        content.text = feed.Content
        
        var textTag = ""
        for t in feed.tags{
            textTag = textTag + t + ", "
        }
        
        tags.text = textTag
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
