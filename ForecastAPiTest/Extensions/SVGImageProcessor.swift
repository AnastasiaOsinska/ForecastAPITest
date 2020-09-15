//
//  SVGImageProcessor.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/15/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

public struct SVGImgProcessor:ImageProcessor {
    public var identifier: String = "com.ForecastAPITest.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
