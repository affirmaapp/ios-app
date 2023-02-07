//
//  SelectedThemeManager.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation
import PostgREST

class SelectedThemeManager: NSObject {
    
    let client = SupabaseManager.shared.client
    
    func fetchSelectedThemeData(forTheme theme: String?,
                                completion: @escaping (([SelectedThemeModel]) -> Void)) async {
        do {
            
            let query = client?.database.from("affirmations_cards")
                .select()
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([SelectedThemeModel].self, from: data)
                    if myStruct.count > 0 {
                        completion(myStruct)
                    }
                    print("QueryResponse: \(myStruct)")
                } else {
                    completion([])
                }
                
            }
        } catch {
            completion([])
        }
    }
    
    func addMessage(forUser userID: String?,
                    withModel model: ReceivedMessagesBaseModel?,
                    addcompletion: @escaping ((Bool) -> Void)) async {
        do {
            if let userID = userID {
                let query = client?.database.from("user_messages_received")
                    .select()
                    .equals(column: "user_id", value: "\(userID)")
                
                Task {
                    let queryResponse = try? await query?.execute()
                    let decoder = JSONDecoder()
                    if let data = queryResponse?.underlyingResponse.data {
                        let myStruct = try! decoder.decode([ReceivedMessagesBaseModel].self, from: data)
                        if myStruct.isEmpty {
                            let _ = try? await setUserMessages(withId: userID)
                            
                            let user_messages = ["messages": model?.messages]
                            let query = client?.database.from("user_messages_received")
                                .update(values: try JSONEncoder().encode(user_messages))
                                .equals(column: "user_id", value: "\(userID)")
                            
                            let _ = try await query?.execute()
                            addcompletion(true)
                            
                        } else {
                            var existingMessages = myStruct[0]
                            if let count = existingMessages.messages?.count, count > 0 {
                                if let messages = model?.messages,
                                   var existingMessagesList = existingMessages.messages {
                                    for message in messages {
                                        for existingMessage in existingMessagesList {
                                            if existingMessage.message_id == message.message_id {
                                                addcompletion(true)
                                                return
                                            }
                                        }
                                        
                                        existingMessages.messages?.append(message)

                                    }
                                    
                                }
                                    
                            } else {
                                existingMessages.messages = model?.messages ?? []
                            }
                            
                            
                            let user_messages = ["messages": existingMessages.messages]
                            let query = client?.database.from("user_messages_received")
                                .update(values: try JSONEncoder().encode(user_messages))
                                .equals(column: "user_id", value: "\(userID)")
                            
                            
                            let _ = try await query?.execute()
                            addcompletion(true)
                        }
                        print("QueryResponse: \(myStruct)")
                    } else {
                       addcompletion(false)
                    }
                }
            }
        } catch {
            addcompletion(false)
        }
    }
    
    func setUserMessages(withId userId: String) async {
        do {
            
            let data: [String: String] = ["user_id": userId]
            let query = client?.database.from("user_messages_received").insert(values: try JSONEncoder().encode(data))
            Task {
                let _ = try? await query?.execute()
                
            }
        } catch {
            print("")
        }
        
    }
}

