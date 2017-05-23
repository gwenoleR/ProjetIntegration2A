//
//  QrCodeViewerViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 23/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import Alamofire

class QrCodeViewerViewController: UIViewController {
    @IBOutlet weak var qrCode: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QrCode"
        
        let parameters: Parameters = [
            "user_id": UserDefaults.standard.string(forKey: "user_id")!,
            "type": "b64"
        ]
        
        Alamofire.request("http://qrcode.soc.catala.ovh/getQrCode", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate().responseJSON{ response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = JSON(result)
                        let qrcodeData = json["b64"].stringValue
                        
                        if let qrCodeImage = Data(base64Encoded: qrcodeData, options: .ignoreUnknownCharacters){
                            let image = UIImage(data: qrCodeImage)
                            self.qrCode.image = image
                        }

                    }
                    
                case .failure:
                    print("Error get QrCode")
                }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
