//
//  ExploreManager.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation

// fetch affirmation images
// fetch affirmation text

// like affirmation - will store image id and affirmation id, image url , affirmation text

class ExploreManager: NSObject {
    
    let client = SupabaseManager.shared.client
    
    func fetchAffirmationImages(completion: @escaping (([AffirmationImage]) -> Void)) async {
        do {
            let query = client?.database.from("self_affirmation_images").select()
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([AffirmationImage].self, from: data)
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
    
    func fetchAffirmationText(completion: @escaping (([AffirmationText]) -> Void)) async {
        do {
            let query = client?.database.from("self_affirmation_text").select()
            
            Task {
                let queryResponse = try? await query?.execute()
                let decoder = JSONDecoder()
                if let data = queryResponse?.underlyingResponse.data {
                    let myStruct = try! decoder.decode([AffirmationText].self, from: data)
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
