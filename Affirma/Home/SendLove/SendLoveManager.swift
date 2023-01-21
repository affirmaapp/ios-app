//
//  SendLoveManager.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation

class SendLoveManager: NSObject {
    
    let client = SupabaseManager.shared.client
    
    func fetchThemeData(completion: @escaping (([ThemeData]) -> Void)) async {
        do {
            let query = client?.database.from("themes").select()
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([ThemeData].self, from: data)
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
}
