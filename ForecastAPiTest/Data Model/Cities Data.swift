//
//  Cities Data.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

class CitiesData {
    
    // MARK: - Properties

    static let shared = CitiesData()
    
    // MARK: - Init

    private init() {}
    
    // MARK: - Coordinates

    let coordinates = [
        Coordinates(lat: 53.902512, lon: 27.561481),
        Coordinates(lat: -33.432388, lon: -70.644047),
        Coordinates(lat: 40.714599, lon: -74.002791),
        Coordinates(lat: 50.080293, lon: 14.428983),
        Coordinates(lat: 52.232090, lon: 21.007139),
        Coordinates(lat: 55.755814, lon: 37.617635),
        Coordinates(lat: 51.497730, lon: -0.117672),
        Coordinates(lat: 41.902689, lon: 12.496176),
        Coordinates(lat: 48.856663, lon: 2.351556),
        Coordinates(lat: 45.490804, lon: -73.565815)
    ]
    
    struct Coordinates {
        var lat: Double
        var lon: Double
    }
}
