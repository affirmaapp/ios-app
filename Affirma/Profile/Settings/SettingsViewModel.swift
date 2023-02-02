//
//  SettingsViewModel.swift
//  Affirma
//
//  Created by Airblack on 02/02/23.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    
    // MARK: Properties

    var detailsSaved: (() -> Void)?
    
    var wasNameChanged: Bool = false
    var wasTimeChanged: Bool = false
    let myGroup = DispatchGroup()
    
    // MARK: Init
    override init() {
        super.init()
        
    }
    
    func saveData(withName name: String?,
                  withHour hour: Int,
                  withMinute minute: Int) {
        Task {
            myGroup.enter()
            myGroup.enter()
            
            let _ = try? await updateName(withName: name, completion: { isSaved in
                self.myGroup.leave()
            })
                                          
            let _ = try? await updateNotificationTime(withHour: hour,
                                                      withMinute: minute, completion: { isSaved in
                self.myGroup.leave()
            })
            
            myGroup.notify(queue: DispatchQueue.main) {
                self.detailsSaved?()
            }
        }
    }
    
    private func updateName(withName name: String?,
                            completion: @escaping ((Bool) -> Void)) async {
        if let name = name {
            await SupabaseManager.shared.setUserName(name: name) { isSaved in
                if isSaved {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func updateNotificationTime(withHour hour: Int,
                                        withMinute minute: Int,
                                        completion: @escaping ((Bool) -> Void)) async {
        await SupabaseManager.shared.setUserNotificationTime(hour: hour,
                                                             minute: minute) { isSaved in
            if isSaved {
                completion(true)
            } else {
                print("error in logging in")
                completion(false)
            }
        }
    }
    
}
