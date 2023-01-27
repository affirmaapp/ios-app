//
//  ReceivedMessagesManager.swift
//  Affirma
//
//  Created by Airblack on 27/01/23.
//

import Foundation
import PostgREST

class ReceivedMessagesManager: NSObject {
    
    let client = SupabaseManager.shared.client
    
    func fetchMessages(completion: @escaping ((ReceivedMessagesBaseModel?) -> Void)) async {
        do {
            
            if let userID = AffirmaStateManager.shared.activeUser?.userId {
                let query = client?.database.from("user_messages_received")
                    .select()
                    .equals(column: "user_id", value: "\(userID)")
               
                Task {
                    let queryResponse = try? await query?.execute()
                    let decoder = JSONDecoder()
                    if let data = queryResponse?.underlyingResponse.data {
                        let myStruct = try! decoder.decode([ReceivedMessagesBaseModel].self, from: data)
                        if myStruct.isEmpty {
                            completion(nil)
                        } else {
                            completion(myStruct[0])
                        }
                        print("QueryResponse: \(myStruct)")
                    } else {
                        completion(nil)
                    }
                    
                }
            } else {
                completion(nil)
            }
           
        } catch {
            completion(nil)
        }
    }
}
