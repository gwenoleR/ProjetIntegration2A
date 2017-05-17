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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        t.text = feed.Titre
        content.text = feed.Content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
