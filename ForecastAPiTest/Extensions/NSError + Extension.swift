//
//  NSError + Extension.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

extension NSError {
    static func error(with description: String) -> NSError {
        return NSError(domain: "ForecastAPITest", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
