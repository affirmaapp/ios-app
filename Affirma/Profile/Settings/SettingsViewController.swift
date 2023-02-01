//
//  SettingsViewController.swift
//  Affirma
//
//  Created by Airblack on 01/02/23.
//

import Foundation
import UIKit

class SettingsViewControllerFactory: NSObject {
    class func produce() -> SettingsViewController {
        let settingVC = SettingsViewController(nibName: "SettingsViewController",
                                               bundle: nil)
        return settingVC
    }
}

class SettingsViewController: BaseViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: GenericButtonView!
    @IBOutlet var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextfield.text = AffirmaStateManager.shared.activeUser?.metaData?.name
        
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.hour = AffirmaStateManager.shared.activeUser?.metaData?.notificationHour
        components.minute = AffirmaStateManager.shared.activeUser?.metaData?.notificationMinute
        if let date = calendar.date(from: components) {
            datePicker.setDate(date, animated: true)
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.nameTextfield.isUserInteractionEnabled = true
        self.nameTextfield.becomeFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
