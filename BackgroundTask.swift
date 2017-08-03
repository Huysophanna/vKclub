import AVFoundation

class BackgroundTask {
    
    static var player = AVAudioPlayer()
    var timer = Timer()
    
    func startBackgroundTask() {
                NotificationCenter.default.addObserver(self, selector: #selector(interuptedAudio), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
                self.playAudio()
    }
    
    func stopBackgroundTask() {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
                BackgroundTask.player.stop()
    }
    
    @objc fileprivate func interuptedAudio(_ notification: Notification) {
        if notification.name == NSNotification.Name.AVAudioSessionInterruption && notification.userInfo != nil {
            var info = notification.userInfo!
            var intValue = 0
            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
            if intValue == 1 { playAudio() }
        }
    }
    
    fileprivate func playAudio() {
        do {
            let bundle = Bundle.main.path(forResource: "ringback", ofType: "wav")
            let alertSound = URL(fileURLWithPath: bundle!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            try BackgroundTask.player = AVAudioPlayer(contentsOf: alertSound)
            BackgroundTask.player.numberOfLoops = -1
            BackgroundTask.player.volume = 0.01
            BackgroundTask.player.prepareToPlay()
            BackgroundTask.player.play()
        } catch { print(error) }
    }
}
