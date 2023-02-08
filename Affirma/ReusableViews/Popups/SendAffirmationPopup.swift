//
//  SendAffirmationPopup.swift
//  Affirma
//
//  Created by Airblack on 22/01/23.
//

import Foundation
import PhoneNumberKit
import UIKit

class SendAffirmationPopup: UIView {
    
    @IBOutlet weak var pickFromContactButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField: PhoneNumberTextField!
    
    var phoneNumber: String?
    
    var sendPressed: ((String?) -> Void)?
    var pickFromContactsPressed: (() -> Void)?
    var popupDismissed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        textField.attributedPlaceholder = Utility
            .getAttributedString(font: Font(.installed(.avenirLight),
                                            size: .custom(12.0)).instance,
                                 color: Colors.black_18181C.withAlpha(0.5),
                                 text: "Enter their number")
        
        textField.setLeftPaddingPoints(10)
        
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true 
        
    }
    
    func render(withNumber number: String) {
        self.textField.text = number
        self.phoneNumber = number
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            self.popupDismissed?()
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let phoneNumberKit = PhoneNumberKit()
//        phoneNumberKit.format(number.va, toType: .e164)
        do {
            var phone = try phoneNumberKit.parse(self.phoneNumber ?? "")
            let formatted = phoneNumberKit.format(phone, toType: .e164)
            print("FINAL PHONE: \(formatted)")
            self.sendPressed?(formatted)
        } catch {
            print("error: \(error)")
        }
    }
    
    @IBAction func pickFromContactPressed(_ sender: Any) {
        self.pickFromContactsPressed?()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss()
    }
}

extension SendAffirmationPopup: UITextFieldDelegate {
    
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
            self.phoneNumber = txtAfterUpdate
        }
        
        return newLength <= 20
    }
}

