//
//  SettingsViewModel.swift
//  Affirma
//
//  Created by Airblack on 02/02/23.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    
    // MARK: Properties

    var reloadName: (() -> Void)?
    var reloadTime: (() -> Void)?
    
    var wasNameChanged: Bool = false
    var wasTimeChanged: Bool = false
    
    // MARK: Init
    override init() {
        super.init()
        
    }
    
    func saveData(withName name: String?,
                  withHour hour: Int,
                  withMinute minute: Int) {
        Task {
            let _ = try? await updateName(withName: name)
            let _ = try? await updateNotificationTime(withHour: hour,
                                                      withMinute: minute)
        }
    }
    
    private func updateName(withName name: String?) async {
        if let name = name {
            await SupabaseManager.shared.setUserName(name: name) { isSaved in
                if isSaved {
                    self.reloadName?()
                } else {
                    print("error in logging in")
                }
            }
        }
    }
    
    private func updateNotificationTime(withHour hour: Int,
                                        withMinute minute: Int) async {
        await SupabaseManager.shared.setUserNotificationTime(hour: hour,
                                                             minute: minute) { isSaved in
            if isSaved {
                self.reloadTime?()
            } else {
                print("error in logging in")
            }
        }
    }
    
}
