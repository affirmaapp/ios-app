//
//  ProfileItemTableViewCell.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation
import UIKit

class ProfileItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reset()
    }
    
    func render(withTitle title: String?,
                witIcon icon: UIImage) {
        reset()
        iconView.image = icon
        titleLabel.text = title
    }
    
    func reset() {
        iconView.image = nil
        titleLabel.text = nil
    }
}
