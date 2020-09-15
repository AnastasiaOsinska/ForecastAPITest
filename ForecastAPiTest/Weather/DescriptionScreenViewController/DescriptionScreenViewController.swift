//
//  DescriptionScreenViewController.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import SVGKit

class DescriptionScreenViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let Url = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
        static let svg = ".svg"
        static let placeholderImageName = "PlaceholderImage"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    private var citiesList: [CityData]?
    private var citymodel: CityData = CityData()
    
    // MARK: - Init
    
    init(cityData: CityData) {
        self.citymodel = cityData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: citymodel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Setup
    
    func setup(with model: CityData) {
        nameLabel.text = model.name
        conditionLabel.text = model.condition
        seasonLabel.text = model.season
        windDirLabel.text = model.wind_dir
        guard let doublewind = model.wind_speed else { return }
        windSpeedLabel.text = "\(doublewind.string)"
        guard let doubletemp = model.temp else { return }
        tempLabel.text = "\(doubletemp.string) degrees"
        setupImage(with: model.image)
    }
    
    // MARK: - Private
    
    private func setupImage(with url: String?) {
        iconWeather.image = nil
        guard let stringUrl = url, let url = URL(string: stringUrl) else {
            iconWeather.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        iconWeather.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
    }
}

