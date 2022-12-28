//
//  AudioManager.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import AVFoundation
import Foundation
import UIKit

class AudioManager {
    static let shared = AudioManager()
    
    func setupAmbientCategory() {
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(AVAudioSession.Category(rawValue:
                                                        convertFromAVAudioSessionCategory(AVAudioSession
                                                                                            .Category
                                                                                            .ambient)))
        } catch {
            print("could not set audio session category")
        }
    }
    
    func setupPlaybackCategory() {
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(AVAudioSession.Category(rawValue:
                                                        convertFromAVAudioSessionCategory(AVAudioSession
                                                                                            .Category
                                                                                            .playback)))
        } catch {
            print("could not set audio session category")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

