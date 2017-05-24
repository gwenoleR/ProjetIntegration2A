//
//  SearchAnnotation.swift
//  JO 2017
//
//  Created by Gwenolé on 18/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import MapKit

class SearchAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var title: String!
    var subtitle: String!
    
    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.name = name
    }
    
}
