//
//  ForecatsData.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Weather: Codable {
    var info: Info?
    var fact: Fact?
}

final class Info: Codable {
    var lat: Double
    var lon: Double
    var url: String?
    var tzinfo: TzInfo
    
    class TzInfo: Codable {
        var name: String
        var abbr: String
    }
}

final class Fact: Codable {
    var temp: Double
    var icon: String
    var condition: String
    var season: String
    var wind_speed: Double
    var wind_dir: String
}

struct CityData {
    var name: String?
    var temp: Double?
    var url: String?
    var image: String?
    var condition: String?
    var season: String?
    var wind_speed: Double?
    var wind_dir: String?
}
