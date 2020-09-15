//
//  ListOfCitiesViewController.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class ListOfCitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate {
    
    // MARK: - Constants
    
    private struct Constants {
        static let standartAnimationDuration: Double = 0.4
        static let spacingBetweenCells: CGFloat = 40
        static let cellCornerRadius: CGFloat = 10
        static let numberOfRowsInSection: Int = 1
        static let loadingTableViewCellName = "loadingTableViewCellName"
        static let nibName = "ListOfCitiesTableViewCell"
        static let cellId = "ListOfCitiesTableViewCellID"
        static let Url = "https://yastatic.net/weather/i/icons/blueye/color/svg/"
        static let svg = ".svg"
    }
    
    // MARK: - Properties
    
    @IBOutlet private weak var navigationBarView: NavigationBarView!
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var cellModels: [Any] = []
    private var citiesList = [CityData]()
    private var weather: Weather?
    private var weatherData: [Weather] = []
    private var loading: Bool = false
    private var showLoadingIndicator: Bool = true
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadCellModels()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func setupView() {
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.cellId)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: Constants.loadingTableViewCellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl.isHidden = true
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        navigationBarView.delegate = self
    }
    
    private func reloadCellModels(completion: (() -> Void)? = nil) {
        guard !loading else {
            return
        }
        citiesList = []
        weatherData = []
        cellModels = []
        showLoadingIndicator = true
        loadData(completion: completion)
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        guard !loading else {
            return
        }
        loading = true
        preloadingState()
        for city in CitiesData.shared.coordinates {
            let queryItems: [APIManager.QueryItems] = [.lat(city.lat),.lon(city.lon), .extra(true)]
            APIManager.shared.getModel (queryItems: queryItems ) { [weak self] result in
                switch result {
                case .success(let resultData):
                    guard let self = self else {
                        return
                    }
                    self.loading = false
                    self.showLoadingIndicator = true
                    self.weatherData.append(resultData)
                    let imageUrl = "\(Constants.Url)\(resultData.fact?.icon ?? "")\(Constants.svg)"
                    let weatherCity = CityData(name: resultData.info?.tzinfo.name, temp: resultData.fact?.temp, url: resultData.info?.url, image: imageUrl, condition: resultData.fact?.condition, season: resultData.fact?.season, wind_speed: resultData.fact?.wind_speed, wind_dir: resultData.fact?.wind_dir)
                    self.citiesList.append(weatherCity)
                    self.buildCellModels(completion: completion)
                case .failure(let error):
                    debugPrint(error)
                }
                self?.loading = false
            }
        }
    }
    
    private func buildCellModels(completion: (() -> Void)? = nil) {
        cellModels = []
        cellModels.append(contentsOf: citiesList)
        if showLoadingIndicator {
            cellModels.append(LoadingModel())
        }
        refreshControl.endRefreshing()
        tableView.reloadData()
        guard let completion = completion else {
            return
        }
        completion()
    }
    
    private func preloadingState() {
        if cellModels.isEmpty || citiesList.isEmpty {
            if showLoadingIndicator {
                let exist = cellModels.contains { (model) -> Bool in
                    return model is LoadingModel
                }
                if !exist {
                    cellModels.append(LoadingModel())
                }
            }
            tableView.reloadData()
        }
    }
    
    private func searchAction(with text: String) {
        guard !text.isEmpty else {
            buildCellModels()
            return
        }
        cellModels = citiesList.filter { ($0.name?.lowercased().contains(text.lowercased()) ?? false) }
        tableView.reloadData()
    }
    // MARK: - Actions
    
    @objc func refresh(_ sender: AnyObject) {
        reloadCellModels()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        guard index < cellModels.count else {
            return UITableViewCell()
        }
        let model = cellModels[index]
        var cell: UITableViewCell
        switch model {
        case let weatherModel as CityData:
            guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? ListOfCitiesTableViewCell else {
                return UITableViewCell()
            }
            weatherCell.setup(with: weatherModel)
            cell = weatherCell
        case _ as LoadingModel:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingTableViewCellName, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            loadingCell.color = .white
            loadingCell.selectionStyle = .none
            return loadingCell
        default:
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        cell.layer.cornerRadius = Constants.cellCornerRadius
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DescriptionScreenViewController(cityData: citiesList[indexPath.section])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ListOfCitiesTableViewCell else { return }
        cell.weatherIcon.kf.cancelDownloadTask()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : Constants.spacingBetweenCells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // MARK: - HeaderViewDelegate
    
    func search(text: String) {
        searchAction(with: text)
    }
    
    func searchBar(is hidden: Bool) {
        if hidden {
            searchAction(with: "")
        }
        UIView.animate(withDuration: Constants.standartAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
