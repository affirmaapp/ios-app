//
//  AffirmationMessageTableViewCell.swift
//  Affirma
//
//  Created by Airblack on 28/01/23.
//

import Foundation
import UIKit

class AffirmationMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: AffirmationCardView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    var topGreeting: [String] = ["Look at {name}, reminding you that you’re a boss",
                                 "{name} just gave you a virtual hug",
                                 "{name} believes in you",
                                 "{name}, reminding you of your powers",
                                 "Think of this affirmation from {name} as a reminder of your worth"]
    
    func render(withModel model: ReceivedMessagesDataModel?) {
        guard let model = model else {
            return
        }
        
        greetingLabel.text = topGreeting.randomElement()?.replacingOccurrences(of: "{name}", with: model.sender_name ?? "your friend")
        cardView.render(withModel: model)
    }
    
}
