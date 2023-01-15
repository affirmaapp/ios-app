//
//  SupabaseManager.swift
//  Affirma
//
//  Created by Airblack on 14/01/23.
//

import Foundation
import Supabase
import SupabaseStorage


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
    
    
    func signIn(withNumber number: String) async {
        do {
            try await client?.auth.signInWithOTP(phone: number)
        } catch {
            print("error in sign in")
        }
    }
    
    func verify(withPhoneNumber number: String, witToken token: String) async {
        do {
            let response = try await client?.auth.verifyOTP(phone: number, token: token, type: .sms)
                print("response: \(response)")
            
        } catch {
            print("error in sign in")
        }
    }
}
