//
//  ScanQRCodeViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 18/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var readed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        
    }

    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            
            if UserDefaults.standard.string(forKey: "user_language") != "en"{
                
                translate(chaine: messageLabel.text!, to: UserDefaults.standard.string(forKey: "user_language")!){ retour in
                    self.messageLabel.text = retour
                }
            }
            
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil && readed == false{
                
                readed = true
                messageLabel.text = "QrCode detected !"

                //Send POST /checkQrCode
                let parameters: Parameters = [
                    "user_id": metadataObj.stringValue
                    ]
                
                Alamofire.request("http://qrcode.soc.catala.ovh/checkQrCode", method: .post, parameters: parameters, encoding: JSONEncoding.default)
.validate().responseJSON{ response in

                    switch response.result {
                    case .success:
                        print("QRCode find")
                        if let result = response.result.value {
                            
                            let json = JSON(result)
                            
                            let id = json["_id"].stringValue
                            let nom = json["perso"]["nom"].stringValue
                            let prenom = json["perso"]["prenom"].stringValue
                            let type = json["perso"]["type"].stringValue
                            print(json["tags"].arrayValue)
                            let language = json["perso"]["language"].stringValue
                            
                            UserDefaults.standard.set(id, forKey: "user_id")
                            UserDefaults.standard.set(nom, forKey: "user_nom")
                            UserDefaults.standard.set(prenom, forKey: "user_prenom")
                            UserDefaults.standard.set(type, forKey: "user_type")
                            UserDefaults.standard.set(language, forKey: "user_language")
   
                        }
                        self.performSegue(withIdentifier: "auth", sender: self);

                    case .failure:
                        print("Error with qrcode")
                        self.readed = false
                        
                    }
                    
                }
                
                
                
                let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
