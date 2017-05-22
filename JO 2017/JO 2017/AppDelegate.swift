//
//  AppDelegate.swift
//  JO 2017
//
//  Created by Gwenolé on 16/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        
        if let _ = UserDefaults.standard.value(forKey: "user_id"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            if let _ = UserDefaults.standard.value(forKey: "first"){
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabController")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            
            
        }
        //MARK : Debug
        //print(locationManager.location?.coordinate)
        return true
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let message = note(fromRegionIdentifier: region.identifier) else { return }
            window?.rootViewController?.showAlert(withTitle: nil, message: message)
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = note(fromRegionIdentifier: region.identifier)
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func note(fromRegionIdentifier identifier: String) -> String? {
        let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
        let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let index = geotifications?.index { $0?.identifier == identifier }
        return index != nil ? geotifications?[index!]?.note : nil
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            let circular : CLCircularRegion = region as! CLCircularRegion
            handleEvent(forRegion: region)
            
            let parameters : Parameters = [
                "_id" : UserDefaults.standard.value(forKey: "user_id")!,
                "poi_id": circular.identifier,
                "inOut": "in"
            ]
            
            Alamofire.request("http://gps.soc.catala.ovh/userPoi", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate().responseJSON{ response in
                                        
                    switch response.result {
                    case .success:
                        print("succcess add user on POI")
                    case .failure:
                        print("error add user on POI")
                    }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            let circular : CLCircularRegion = region as! CLCircularRegion
            //handleEvent(forRegion: region)
            
            let parameters : Parameters = [
                "_id" : UserDefaults.standard.value(forKey: "user_id")!,
                "poi_id": circular.identifier,
                "inOut": "out"
            ]

            Alamofire.request("http://gps.soc.catala.ovh/userPoi", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate().responseJSON{ response in
                    
                    if let result = response.result.value {
                        print(parameters)
                        print(result)
                    }
                    
                    switch response.result {
                    case .success:
                        print("succcess rm user on POI")
                    case .failure:
                        print("error rm user on POI")
                    }
            }
        }
    }
}


