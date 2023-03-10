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
    @IBOutlet weak var notificationAlertLabel: UILabel!
    @IBOutlet weak var notificationPermissionButton: UIButton!
    
    
    var viewModel: SettingsViewModel?
    fileprivate var name: String?
    fileprivate var notificationHour: Int = 16
    fileprivate var notificationMinute: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModel()
        
        setName()
        setDate()
        saveButton.render(withType: .inactive, withText: "Save")
        handleCallback()
        
        nameTextfield.addDoneButtonOnKeyboard()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter
            .addObserver(self,
                         selector: #selector(appMovedToForeground),
                         name: UIApplication.willEnterForegroundNotification,
                         object: nil)
        EventManager.shared.trackEvent(event: .landedOnSettingsScreen)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        setUI()
        
    }
    
    @objc
    func appMovedToForeground() {
        setUI()
    }
    
    
    func setName() {
        nameTextfield.delegate = self
        nameTextfield.text = AffirmaStateManager.shared.activeUser?.metaData?.name
        self.name = AffirmaStateManager.shared.activeUser?.metaData?.name
    }
    
    func setDate() {
        
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.hour = AffirmaStateManager.shared.activeUser?.metaData?.notification_hour
        components.minute = AffirmaStateManager.shared.activeUser?.metaData?.notification_minute
        
        self.notificationHour = AffirmaStateManager.shared.activeUser?.metaData?.notification_hour ?? 16
        self.notificationMinute = AffirmaStateManager.shared.activeUser?.metaData?.notification_minute ?? 0
        
        if let date = calendar.date(from: components) {
            datePicker.setDate(date, animated: true)
        }

    }
    
    func setUI() {
        NotificationManager.shared.doWeHavePermission { isGranted in
            if isGranted {
                DispatchQueue.main.async {
                    self.notificationAlertLabel.isHidden = true
                    self.notificationPermissionButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.notificationAlertLabel.isHidden = false
                    self.notificationPermissionButton.isHidden = false
                }
            }
        }
    }
    
    func handleCallback() {
        saveButton.primaryCtaClicked = {
            self.showFullScreenLoader()
            self.viewModel?.saveData(withName: self.name,
                                withHour: self.notificationHour,
                                withMinute: self.notificationMinute)
        }
        
        viewModel?.detailsSaved = {
            EventManager.shared.trackEvent(event: .savePressed)
            self.notifyUser()
            self.hideFullScreenLoader()
        }
    }
    
    func notifyUser() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Details saved!",
                                          message: "",
                                          preferredStyle: .alert)
            
            // add the actions (buttons)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
                print("dismiss")
                
                self.navigationController?.popViewController(animated: true)
            })
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func askForNotificationPermission(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func checkForCta() {
        if (viewModel?.wasNameChanged ?? false) || (viewModel?.wasTimeChanged ?? false) {
            if let count = nameTextfield.text?.count, count > 0 {
                saveButton.render(withType: .primaryCta, withText: "Save")
            } else {
                saveButton.render(withType: .inactive, withText: "Save")
            }
        } else {
            saveButton.render(withType: .inactive, withText: "Save")
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        viewModel?.wasNameChanged = true
        checkForCta()
        self.nameTextfield.isUserInteractionEnabled = true
        self.nameTextfield.becomeFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        viewModel?.wasNameChanged = true
        checkForCta()
        
        print("Selected Date: \(datePicker.date)")
        var components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        let hour = components.hour
        let minute = components.minute
        components.year = 2023
        print("Components: \(components)")
        
        print("Hour: \(String(describing: hour)), \(String(describing: minute))")
        self.notificationHour = hour ?? 16
        self.notificationMinute = minute ?? 0
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension SettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length

        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            self.name = txtAfterUpdate
        }
        
        checkForCta()
        
        return true
    }
}
