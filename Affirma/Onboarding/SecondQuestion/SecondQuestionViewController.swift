//
//  SecondQuestionViewController.swift
//  Affirma
//
//  Created by Airblack on 11/01/23.
//

import Foundation
import UIKit

class SecondQuestionViewControllerFactory: NSObject {
    class func produce(withName name: String?) -> SecondQuestionViewController {
        let secondQuesVC = SecondQuestionViewController(nibName: "SecondQuestionViewController",
                                                       bundle: nil)
        secondQuesVC.name = name
        return secondQuesVC
    }
}

class SecondQuestionViewController: BaseViewController {
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backButton: GenericButtonView!
    @IBOutlet weak var forwardButton: GenericButtonView!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    fileprivate var name: String?
    fileprivate var notificationHour: Int = 16
    fileprivate var notificationMinute: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        handleTap()
        
        EventManager.shared.trackEvent(event: .landedOnNotificationScreen)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
        
    }
    
    private func setUI() {
        
        greetingText.setTextWithTypeAnimation(typedText: "Awesome \(name ?? ""),\nYou're almost there!")
        mediaView.render(withImage: nil,
                         withVideo: nil,
                         withGif: "fifthStep")
        
        let config = ButtonConfig(withTextColor: Colors.black_1A1B1C.value,
                                  withBackgroundColor: Colors.white_E5E5E5.value,
                                  withImage: UIImage(named: "arrowForward"),
                                  isImageInRight: true)
        forwardButton.render(withConfig: config, withText: "Next ", withTag: 0)
        
        
        let backButtonConfig = ButtonConfig(withTextColor: Colors.white_E5E5E5.value,
                                  withBackgroundColor: .clear,
                                  withImage: UIImage(named: "backButton"))
        backButton.render(withConfig: backButtonConfig, withText: "Back ", withTag: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.date(from: "16:00")
        if let date = date {
            datePicker.date = date
        }
    }
    
    private func updateNotificationTime(withHour hour: Int,
                                        withMinute minute: Int) async {
        await SupabaseManager.shared.setUserNotificationTime(hour: hour,
                                                             minute: minute) { isSaved in
            if isSaved {
                let properties: [String: Any] = ["hour": hour , "minute": minute]
                EventManager.shared.trackEvent(event: .notificationTimeEntered,
                                               properties: properties)
                DispatchQueue.main.async {
                    let introVC = IntroScreenViewControllerFactory.produce()
                    self.navigationController?.pushViewController(introVC, animated: true)
                }
            } else {
                print("error in logging in")
            }
        }
    }

    @IBAction func dateChanged(_ sender: Any) {
        print("Selected Date: \(datePicker.date)")
        let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        let hour = components.hour
        let minute = components.minute
        
        print("Hour: \(String(describing: hour)), \(String(describing: minute))")
        
        let properties: [String: Any] = ["hour": hour ?? 0, "minute": minute ?? 0]
        EventManager.shared.trackEvent(event: .notificationTimeChanged,
                                       properties: properties)
        self.notificationHour = hour ?? 16
        self.notificationMinute = minute ?? 0
    }
    
    private func handleTap() {
        forwardButton.customCtaCtaClicked = { tag in
            NotificationManager.shared.askForUsersPermission { responseReceived in
                if responseReceived {
                    Task {
                        try await self.updateNotificationTime(withHour: self.notificationHour,
                                                              withMinute: self.notificationMinute)
                    }
                }
            }
        }
        
        backButton.customCtaCtaClicked = { tag in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
