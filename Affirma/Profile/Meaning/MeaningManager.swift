//
//  MeaningManager.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation

class MeaningManager: NSObject {
    
    let client = SupabaseManager.shared.client
    
    func fetchSymbolMeanings(completion: @escaping (([MeaningModel]) -> Void)) async {
        do {
            let query = client?.database.from("symbol_meanings").select()
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([MeaningModel].self, from: data)
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
