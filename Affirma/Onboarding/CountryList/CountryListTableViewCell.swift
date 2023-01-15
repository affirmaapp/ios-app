//
//  CountryListTableViewCell.swift
//  Airblack
//
//  Created by Vidushi Jaiswal on 04/03/21.
//

import Foundation
import UIKit

// MARK: Protocol

class CountryListTableViewCell: UITableViewCell {
    // MARK: Outlets
    
    @IBOutlet weak private var mediaView: GenericMediaView!
    @IBOutlet weak private var countryCodeLabel: UILabel!
    @IBOutlet weak private var countryNameLabel: UILabel!
    // MARK: Properties
    
    // MARK: Lifecycle Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Setting Up UI
    func render(forCountry country: CountryModel?) {
        reset()
        if let country = country {
            
            if let phoneCode = country.phoneCode {
                countryCodeLabel.text = "\(country.flag ?? "") " + phoneCode
            }
            
            if let countryName = country.name {
                countryNameLabel.text = countryName
            }
        }
    }
    
    func render(withString title: String?) {
        guard let title = title else {
            return
        }

        reset()
        countryNameLabel.text = title
    }
    
    // MARK: Actions
}

// MARK: Helper Functions
extension CountryListTableViewCell {
    private func reset() {
        countryCodeLabel.text = ""
        countryNameLabel.text = ""
        mediaView.isHidden = true 
    }
}
