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
            print("error in sign in")
            completion(false)
        }
    }
}

// Set User functions
extension SupabaseManager {
    
    func setUser(completion: @escaping ((Bool) -> Void)) async {
        do {
            let user = try await client?.auth.session.user
            let affirmaUser = AffirmaUser()
            affirmaUser.userId = user?.id
            affirmaUser.phoneNumber = user?.phone
            AffirmaStateManager.shared.login(withUser: affirmaUser)
            
            if let userId: UUID = user?.id {
                let data: [String: UUID] = ["userId": userId]
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
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_metadata")
                    .update(values: try JSONEncoder().encode(data))
                    .equals(column: "userId", value: "\(userID)")
                
                Task {
                    let _ = try? await query?.execute()
                    completion(true)
                }
            }
           
        } catch {
            completion(false)
        }
    }
    
    func setUserNotificationTime(time: Int,
                     completion: @escaping ((Bool) -> Void)) async {
        do {
            let data: [String: Int] = ["notificationTime": time]
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_metadata")
                    .update(values: try JSONEncoder().encode(data))
                    .equals(column: "userId", value: "\(userID)")
                
                Task {
                    let _ = try? await query?.execute()
                    completion(true)
                }
            }
           
        } catch {
            completion(false)
        }
    }
}
