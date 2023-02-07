//
//  SupabaseManager.swift
//  Affirma
//
//  Created by Airblack on 14/01/23.
//

import Foundation
import Supabase
import GoTrue
import SupabaseStorage
import ObjectMapper


class SupabaseManager: NSObject {
    
    var client: SupabaseClient?
    
    @objc static let shared = SupabaseManager()
    
    override init() {
        super.init()
        
        if let url = URL(string: "https://apnleuezyregngrryoaf.supabase.co") {
            client = SupabaseClient(supabaseURL: url,
                                    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwbmxldWV6eXJlZ25ncnJ5b2FmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzM2MDgzMTEsImV4cCI6MTk4OTE4NDMxMX0.1dZ00Uv7UcpjHWjt9uo4FprMxolgA9IRHkJhnpwItEc")
        }
    }
    
    private func encode(model: [String: String]) throws -> Any {
        guard let data = try? JSONEncoder().encode(model),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            print("")
            throw NSError()
        }
        
        return dictionary
    }
    
    func updateUserName(name: String,
                        completion: @escaping ((Bool) -> Void)) async {
        do {
            
            let encoder = JSONEncoder()
            
            let json: [String: String] = ["name": "\(name)"]
            
            let data = try encoder.encode(json)
            
            let decoder = JSONDecoder()
            
            let result = try decoder.decode(AnyJSON.self, from: data) // decoding error
            
            print("JSON::: \(result)")
            do {
                
                let user = try await client?.auth.update(user: UserAttributes(data: ["name": result]))
                
                completion(true)
            } catch let error as NSError {
                print(error)
            }
        } catch {
            completion(false)
        }
    }
    
}


// Auth functions
extension SupabaseManager {
    
    func signIn(withNumber number: String) async {
        do {
            try await client?.auth.signInWithOTP(phone: number)
        } catch {
            print("error in sign in")
        }
    }
    
    func verify(withPhoneNumber number: String,
                witToken token: String,
                completion: @escaping ((Bool) -> Void)) async {
        do {
            let response = try await client?.auth.verifyOTP(phone: number, token: token, type: .sms)
            print("response: \(String(describing: response))")
            if let response = response {
                Task {
                    try await self.setUser() { isSet in
                        
                    }
                }
                
                completion(true)
            }
        } catch {
            print("error in sign in: \(error)")
            completion(false)
        }
    }
    
    func logout() async {
        do {
            let response = try await client?.auth.signOut()
            AffirmaStateManager.shared.logout()
        } catch {
            print("error in sign in")
        }
    }
}

// Set User functions
extension SupabaseManager {
    
    func isUserPresent(completion: @escaping ((Bool) -> Void)) async {
        do {
            let user = try? await client?.auth.session.user
            if user?.id == nil {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
           completion(false)
        }
    }
    
    func isUserActive(completion: @escaping ((Bool) -> Void)) {
        if let state = AffirmaStateManager.shared.activeUser?.metaData?.state,
           state == "ACTIVE" {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func setUser(completion: @escaping ((Bool) -> Void)) async {
        do {
            let user = try await client?.auth.session.user
            let affirmaUser = AffirmaUser()
            affirmaUser.userId = user?.id
            affirmaUser.phoneNumber = user?.phone
            AffirmaStateManager.shared.login(withUser: affirmaUser)
            
            if let userId: String = user?.id.uuidString,
               let phone = user?.phone {
                let data: [String: String] = ["user_id": userId,
                                              "phone": phone]
                let query = client?.database.from("user_metadata").insert(values: try JSONEncoder().encode(data))
                Task {
                    let _ = try? await query?.execute()
                }
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    

    func setUserName(name: String,
                     completion: @escaping ((Bool) -> Void)) async {
        do {
            let data: [String: String] = ["name": name]
            var metaData = AffirmaUserMetaData()
            metaData.name = name

            AffirmaStateManager.shared.activeUser?.metaData = metaData
            AffirmaStateManager.shared.saveActiveUser()
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_metadata")
                    .update(values: try JSONEncoder().encode(data))
                    .equals(column: "user_id", value: "\(userID)")
                
                Task {
                    let _ = try? await query?.execute()
                    completion(true)
                }
            }
           
        } catch {
            completion(false)
        }
    }
    
    func setUserNotificationTime(hour: Int,
                                 minute: Int,
                                 completion: @escaping ((Bool) -> Void)) async {
        do {
            let data: [String: Int] = ["notification_hour": hour,
                                       "notification_minute": minute]
            AffirmaStateManager.shared.activeUser?.metaData?.notification_hour = hour
            AffirmaStateManager.shared.activeUser?.metaData?.notification_minute = minute
            AffirmaStateManager.shared.saveActiveUser()
            
            NotificationManager.shared.scheduleNotification()
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_metadata")
                    .update(values: try JSONEncoder().encode(data))
                    .equals(column: "user_id", value: "\(userID)")
                
                Task {
                    let _ = try? await query?.execute()
                    completion(true)
                }
            }
           
        } catch {
            completion(false)
        }
    }
    
    func setState(to state: String,
                  completion: @escaping ((Bool) -> Void)) async {
        do {
            let data: [String: String] = ["state": state]
            AffirmaStateManager.shared.activeUser?.metaData?.state = state
            AffirmaStateManager.shared.saveActiveUser()
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_metadata")
                    .update(values: try JSONEncoder().encode(data))
                    .equals(column: "user_id", value: "\(userID)")
                
                Task {
                    let _ = try? await query?.execute()
                    completion(true)
                }
            }
           
        } catch {
            completion(false)
        }
    }
    
    func fetchUser(completion: @escaping ((Bool) -> Void)) async {
        do {
            let user = try await client?.auth.session.user
            print("User present: \(user?.id)")
            
            let affirmaUser = AffirmaUser()
            affirmaUser.userId = user?.id
            affirmaUser.phoneNumber = user?.phone
            AffirmaStateManager.shared.saveActiveUser()
            // fetch meta
            Task {
                _ = try? await fetchUserMetaData(forId: user?.id.uuidString, completion: { isMetaDataSet in
                    if isMetaDataSet {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
                
            }
        } catch {
            print("User not present")
            completion(false)
        }
    }
    
    func doesUserExist(forNumber number: String,
                       completion: @escaping ((Bool, String?) -> Void)) {
        do {
            let query = client?.database.from("user_metadata")
                .select().filter(column: "phone", operator: .eq, value: number)
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([UserData].self, from: data)

                    if myStruct.count > 0 {
                        let user = myStruct[0].user_id
                        completion(true, user?.uuidString)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            }
        } catch {
            completion(false, nil)
        }
        
        
    }
    
    func fetchUserMetaData(forId userId: String?,
                           completion: @escaping ((Bool) -> Void)) async {
        guard let userId = userId else {
            return
        }
        do {
            let query = client?.database.from("user_metadata")
                .select()
                .equals(column: "user_id", value: "\(userId)")
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([UserData].self, from: data)
//                    let json = try! JSONSerialization.jsonObject(with: data,
//                                                                 options: JSONSerialization.ReadingOptions.allowFragments) as! Any
                    
                    if myStruct.count > 0 {
                        let user = myStruct[0]
                        let metaData = AffirmaUserMetaData()
                        metaData.name = user.name
                        metaData.state = user.state
                        metaData.notification_hour = user.notification_hour
                        metaData.notification_minute = user.notification_minute
                        
                        AffirmaStateManager.shared.activeUser?.metaData = metaData
                        AffirmaStateManager.shared.saveActiveUser()
                        completion(true)
                    }
                    print("QueryResponse: \(myStruct)")
                } else {
                    completion(false)
                }
               
            }
        } catch {
            completion(false)
        }
    }
}
