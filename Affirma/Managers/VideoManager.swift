//
//  VideoManager.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import AVFoundation
import Foundation
import Player

class VideoManager: NSObject {
    @objc static let shared = VideoManager()
    let player = Player()
    let liveStreamPlayer = Player()
    var isPlaying = false
    private override init() {
        super.init()
        player.bufferSizeInSeconds = 1
        player.muted = true
        player.playbackResumesWhenEnteringForeground = false
        player.playbackResumesWhenBecameActive = false
    }
    
    func stopPlayer() {
        if isPlaying == true {
            stopVideo()
        }
    }
    
    func stopVideo() {
        player.playerDelegate = nil
        player.playbackDelegate = nil
        player.stop()
        player.url = nil
        AudioManager.shared.setupAmbientCategory()
        isPlaying = false
    }
    
    func startPlayer(withUrl url: URL?) {
        if let url = url {
            isPlaying = true
            player.url = url
            player.muted = false
            player.playFromBeginning()
            AudioManager.shared.setupPlaybackCategory()
        }
    }
    
    func handlePlayPause() {
        if isPlaying {
            pausePlayer()
        } else {
            playAgain()
        }
    }
    
    func pausePlayer() {
        isPlaying = false
        AudioManager.shared.setupAmbientCategory()
        player.pause()
    }
    
    func playAgain() {
        isPlaying = true
        AudioManager.shared.setupPlaybackCategory()
        player.playFromCurrentTime()
    }
}

