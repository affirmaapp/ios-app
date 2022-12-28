//
//  GenericVideoView.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import Foundation
import Player
import UIKit

class GenericVideoView: UIView {
    
    @IBOutlet var genericVideoView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player: Player? = VideoManager.shared.player
    var shouldRestartAutomatically: Bool? = true
    var video: String?
    var isAspectFit: Bool?
    var launchVideoController: ((String?) -> Void)?
    
    // MARK: Lifecycle Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericVideoView", owner: self, options: nil)
        addSubview(genericVideoView)
        genericVideoView.frame = self.bounds
        genericVideoView.fixInView(self)
    }
    
    func render(withVideo video: String?,
                withPlaceholderImage placeholder: UIImage?,
                isAspectFit: Bool?) {
        reset()
        shouldRestartAutomatically = false
        self.video = video
        self.isAspectFit = isAspectFit
        
        if let placeholder = placeholder {
            placeholderImage.isHidden = false
            placeholderImage.image = placeholder
        }
        
    }
    
    @IBAction func playPressed(_ sender: Any) {
        self.launchVideoController?(self.video)
    }
    
}

// MARK: Helper Functions
extension GenericVideoView {
    func setupPlayer(isAspectFit: Bool?) {
        if let playerView = player?.view {
            if genericVideoView.subviews.contains(playerView) {
                playerView.removeFromSuperview()
            }
            if !genericVideoView.subviews.contains(playerView) {
                genericVideoView.addSubview(playerView)
                player?.view.bounds = genericVideoView.bounds
                player?.view.fixInView(genericVideoView)
            }
        }
        
        if let isAspectFit = isAspectFit, isAspectFit == true {
            player?.fillMode = .resizeAspect
        } else {
            player?.fillMode = .resizeAspectFill
        }
        player?.playerLayer()?.masksToBounds = true
        
        player?.playerDelegate = self
        player?.playbackDelegate = self
    }
    
    func reset() {
        placeholderImage.image = nil
        video = nil
        playPauseButton.isHidden = true
        placeholderImage.isHidden = true
    }
    
    func stopVideo() {
        playPauseButton.isHidden = false
        VideoManager.shared.stopVideo()
    }
    
    func beginPlaying(withVideo video: String?) {
        if let video = video {
            let videoString = video.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: videoString) {
                player?.playerDelegate = self
                player?.playbackDelegate = self
                if let isAspectFit = isAspectFit {
                    setupPlayer(isAspectFit: isAspectFit)
                } else {
                    setupPlayer(isAspectFit: false)
                }
                VideoManager.shared.startPlayer(withUrl: url)
                playPauseButton.isHidden = false
            }
        }
    }
}

extension GenericVideoView: PlayerDelegate, PlayerPlaybackDelegate {
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {

    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        if let shouldRestart = shouldRestartAutomatically, shouldRestart == true {
            player.playFromBeginning()
        } else {
           
        }
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
}
