//
//  NavigationBarView.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func search(text: String)
    func searchBar(is hidden: Bool)
}

final class NavigationBarView: NibLoadingView, UISearchBarDelegate {
    
    // MARK: - Constants

    private struct Constants {
        static let animationDuration: TimeInterval = 0.5
    }

    // MARK: - Properties

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    var delegate: HeaderViewDelegate?
    private var searchStr = ""
    var searchBarIsHidden: Bool = true {
        didSet {
            updateSearchBar()
            delegate?.searchBar(is: searchBarIsHidden)
        }
    }
    
    // MARK: - View life cycle

    override func awakeFromNib() {
        searchBar.delegate = self
        searchBarIsHidden = true
    }
    
    // MARK: - Private
    
    private func updateSearchBar() {
        searchBar.text = ""
        searchBarView.isHidden = searchBarIsHidden
        searchButton.alpha = searchBarIsHidden ? 1 : 0
        searchButton.isHidden = !searchBarIsHidden
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchBarIsHidden = false
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        searchBarIsHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        searchStr = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        delegate?.search(text: searchStr)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .white, textColor: .darkGray)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .darkGray, textColor: .white)
    }
}
