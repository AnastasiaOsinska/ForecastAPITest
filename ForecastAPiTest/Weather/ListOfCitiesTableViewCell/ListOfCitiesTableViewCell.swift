//
//  ListOfCitiesTableViewCell.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import SVGKit


class ListOfCitiesTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private struct Constants {
        static let standartAnimationDuration: Double = 0.4
        static let standartNumberOfLines = 3
        static let backgroundViewRadius: CGFloat = 10
        static let placeholderImageName = "PlaceholderImage"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    // MARK: - Setup
    
    func setup(with model: CityData) {
        cityName.numberOfLines = Constants.standartNumberOfLines
        cityName.text = model.name
        guard let double = model.temp else { return }
        tempLabel.text = "\(double.string) degrees"
        setupImage(with: model.image)
    }
    
    // MARK: - Private
    
    private func setupImage(with url: String?) {
        weatherIcon.image = nil
        guard let stringUrl = url, let url = URL(string: stringUrl) else {
            weatherIcon.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        weatherIcon.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
    }
}

