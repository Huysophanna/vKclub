import AVFoundation

var noSoundBGPlayer = AVAudioPlayer()

class BackgroundTask {
    
    static let backgroundTaskInstance = BackgroundTask()
    var timer = Timer()
    
    func startBackgroundTask() {
        NotificationCenter.default.addObserver(self, selector: #selector(interuptedAudio), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        
        self.playAudio()
        
        print("==STARTAUDIOPLAYING==")
    }
    
    func stopBackgroundTask() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        noSoundBGPlayer.stop()
        print("==STOPAUDIOPLAYING==")
    }
    
    @objc fileprivate func interuptedAudio(_ notification: Notification) {
        if notification.name == NSNotification.Name.AVAudioSessionInterruption && notification.userInfo != nil {
            var info = notification.userInfo!
            var intValue = 0
            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
            if intValue == 1 { playAudio() }
        }
        print("NOTPLAYING")
    }
    
    fileprivate func playAudio() {
        do {
            let bundle = Bundle.main.path(forResource: "noSound", ofType: "wav")
            let alertSound = URL(fileURLWithPath: bundle!)
            try noSoundBGPlayer = AVAudioPlayer(contentsOf: alertSound)
            noSoundBGPlayer.numberOfLoops = -1
            noSoundBGPlayer.volume = 0.01
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            noSoundBGPlayer.prepareToPlay()
            noSoundBGPlayer.play()
        } catch { print(error) }
    }
}
