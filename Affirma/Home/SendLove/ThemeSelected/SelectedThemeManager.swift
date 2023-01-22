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
}

