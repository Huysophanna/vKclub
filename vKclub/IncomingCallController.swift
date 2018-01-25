//
//  IncomingCallController.swift
//  vKclub
//
//  Created by HuySophanna on 5/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import CoreData
import MediaPlayer
import CallKit

class IncomingCallController: UIViewController {
    @IBOutlet weak var callerNameLabel: UILabel!
    @IBOutlet weak var callerIDLabel: UILabel!
    @IBOutlet weak var speakerBtn: RoundButton!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var muteBtn: RoundButton!
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var callingDurationLabel: UILabel!
    @IBOutlet weak var rejectCallBtn: UIButton!
    @IBOutlet weak var answerCallBtn: UIButton!
    @IBOutlet weak var endCallBtn: UIButton!
    
    var callDuration = ""
    var defaultPlayer = MPMusicPlayerController.systemMusicPlayer()
    static var callLogTime = ""
    var callLogData = [SipCallData]()
    var callDataRequest: NSFetchRequest<SipCallData> = SipCallData.fetchRequest()
    let userCoreDataInstance = UserProfileCoreData()
    var callKitManager: CallKitCallInit?
    let callController = CXCallController()
    static var dialPhoneNumber: String = ""
    
    static var waitForStreamRunningInterval: Timer?
    static var setUpCallInProgressInterval: Timer?
    
    static var IncomingCallFlag = false
    var incomingCallFlags = false {
        didSet {
            //listen for incoming call event
            IncomingCallController.IncomingCallFlag = incomingCallFlags
            if incomingCallFlags == true {
                getsimCall = true
                print(IncomingCallController.IncomingCallFlag, "----1variable")
                //stop AVAudioPlayer background task while about to call
//                BackgroundTask.backgroundTaskInstance.stopBackgroundTask()
                //Display CallKit for iOS 10
                if #available(iOS 10, *) {
                    AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: LinphoneManager.getContactName()) { _ in
                        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                    }
                }
                
            }
        }
    }
    
    static var CallToAction = false
    var callToFlag = false {
        didSet {
            print(callToFlag ,"+++++")
            IncomingCallController.CallToAction = callToFlag
            if callToFlag == true {
                print("-----", IncomingCallController.IncomingCallFlag ,"+++++")
                if IncomingCallController.IncomingCallFlag == false {
                    PresentIncomingVC()
                    print("-------CALLTO_BEING_FREE_NOT_WITH_SOMEONE_ELSE--------")
                    //stop AVAudioPlayer background task while about to call
//                    BackgroundTask.backgroundTaskInstance.stopBackgroundTask()
                } else {
                    print("--------CALLTO_BEING_BUSY_WITH_SOMEONE_ELSE--------")
                }
            }
        }
    }
    
    static var CallStreamRunning = false
    var callStreamRunning = false {
        didSet {
            //stop backgroundTask since making call interrupt and end our audio backgroundTask
            //            player.stop()
            IncomingCallController.CallStreamRunning = callStreamRunning
            
            print("callStreamRunning ====YAYY====", IncomingCallController.CallStreamRunning)
        }
    }
    
    static var AcceptCallFlag = false
    var acceptCallFlag = false {
        didSet {
            IncomingCallController.AcceptCallFlag = acceptCallFlag
            print("AcceptedCallStream ====YAYY====")
            if IncomingCallController.AcceptCallFlag {
                AcceptCallAction()
            }
        }
    }
    
    static var EndCallFlag = false
    var endCallFlag = false {
        didSet {
            IncomingCallController.EndCallFlag = endCallFlag
            print("EndedCallStream ====YAYY====")
        }
    }
    
    var releaseCallFlag = false {
        
        didSet {
            UIDevice.current.isProximityMonitoringEnabled = false
            //listen for release call event and dismiss the incoming call view
            if releaseCallFlag == true {
                IncomingCallController.CallStreamRunning = false
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                let endCallAction = CXEndCallAction(call: lastCallUUID)
                let callTransaction = CXTransaction(action: endCallAction)
                callController.request(callTransaction, completion: {(data) in })
                
                print("RELEASE, SET CALL DURATION---")
                //set flag back to false when call released
                incomingCallFlags = false
                acceptCallFlag = false
                callToFlag = false
                endCallFlag = false
                callStreamRunning = false
                
                //invalidate wait for stream running interval
                IncomingCallController.InvalidateWaitForStreamRunningInterval()
                //invalidate set up call in progress interval
                IncomingCallController.InvalidateSetUpCallInProgressInterval()
                //Linephone call will destory the audio session when the call ends, so wait for 5seconds to restart the AVAudioPlayer background task
//                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(WaitToStartBackgroundTask), userInfo: nil, repeats: false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.isProximityMonitoringEnabled = true
        callKitManager = CallKitCallInit(uuid: UUID(), handle: "")
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        callDataRequest = SipCallData.fetchRequest()
        //Set all image buttons
        SetImageBtn(button: speakerBtn, imageName: "speaker-icon", imgEdgeInsets: 25)
        SetImageBtn(button: muteBtn, imageName: "mute-icon", imgEdgeInsets: 25)
        SetImageBtn(button: rejectCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        SetImageBtn(button: answerCallBtn, imageName: "call-answer", imgEdgeInsets: 13)
        SetImageBtn(button: endCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        //stop the outGoingCallSound while in call progress
        //        if MPMusicPlayerController.systemMusicPlayer().playbackState == .playing {
        //            defaultPlayer.pause()
        //        }
        //Interval waiting for callstream running, invalidate while call is in progress
        if IncomingCallController.waitForStreamRunningInterval == nil {
            IncomingCallController.waitForStreamRunningInterval = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(IncomingCallController.WaitForStreamRunning), userInfo: nil, repeats: true)
        }
        if IncomingCallController.CallToAction {
            //User makes call to other person
            PrepareCallToActionUI()
            
        } else {
            //User receives call, set contact name & caller number label for incoming call VC
            callerNameLabel.text = LinphoneManager.getContactName()
            callerIDLabel.text = LinphoneManager.getCallerNb()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //*** This is required to fix navigation bar forever disappear on fast backswipe bug.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//    func WaitToStartBackgroundTask() {
//        BackgroundTask.backgroundTaskInstance.startBackgroundTask()
//    }
    
    func SetCallDurationToCoreData() {
        for _callData in callLogData {
            if _callData.callLogTime != nil {
                if _callData.callLogTime! == IncomingCallController.callLogTime {
                    let callDataItemToUpdate = userCoreDataInstance.getCallDataByID(_id: _callData.objectID)
                    callDataItemToUpdate?.callDuration = callDuration
                    do {
                        try manageObjectContext.save()
                        RecentCallController.LoadCallDataCell()
                    } catch {
                        print("SET CALLDURATION TO COREDATA ERROR \(error.localizedDescription) ===")
                    }
                }
            }
        }
    }
    
    func WaitForStreamRunning() {
        print(LinphoneManager.linphoneCallStatus, "===OKAY===")
        //play outGoingCallSound for callToAction
        if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALL_OUTGOING_RINGING {
            outGoingCallPlayer.prepareToPlay()
            outGoingCallPlayer.play()
        }
        if IncomingCallController.AcceptCallFlag == true {
            AcceptCallAction()
        }
        
        if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            print("LINPHONE_CALLSTREAM_RUNNING -------- ", LinphoneManager.interuptedCallFlag)
            
            //invalidate wait for stream running interval
            IncomingCallController.InvalidateWaitForStreamRunningInterval()
            
            //stop the outGoingCallSound while in call progress
            if outGoingCallPlayer.isPlaying {
                outGoingCallPlayer.stop()
            }
            
            print("waitForStreamRunningInterval ========")
            
            PrepareInCallProgressUI()
        }
        
        //LinphoneCallError occurred
        if LinphoneManager.CheckLinphoneConnectionStatus() == false {
            
            //invalidate wait for stream running interval
            IncomingCallController.InvalidateWaitForStreamRunningInterval()
            
            ResetAllFlagVariable()
            
            PresentAlertController(title: "Something went wrong", message: "You are not connected to our server. Please ensure that you are connected to our network and try again later.", actionTitle: "Okay")
        }
        
    }
    
    func PrepareCallToActionUI() {
        print(IncomingCallController.dialPhoneNumber, "====NB==")
        callerNameLabel.text = IncomingCallController.dialPhoneNumber
        callerIDLabel.text = IncomingCallController.dialPhoneNumber
        callingDurationLabel.text = "Dialling"
        answerCallBtn.isHidden = true
        rejectCallBtn.isHidden = true
        endCallBtn.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func EndCallBtnClicked(_ sender: Any) {
        UIDevice.current.isProximityMonitoringEnabled = false
        if LinphoneManager.CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            //decline call
            LinphoneManager.endCall()
            releaseCallFlag = true
            print(LinphoneManager.CheckLinphoneCallState(), "JONGMER==")
            
            //invalidate wait for stream running interval
            IncomingCallController.InvalidateWaitForStreamRunningInterval()
            
        } else if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            IncomingCallController.EndCallFlag = true
            linphone_core_terminate_all_calls(LinphoneManager.lcOpaquePointerData)
        }
    }
    
    @IBAction func DeclineCallBtnClicked(_ sender: Any) {
        DeclineCallAction()
    }
    
    func DeclineCallAction() {
        LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
        print("STH")
        incomingCallFlags = false
        releaseCallFlag = true
        //invalidate wait for stream running interval
        IncomingCallController.InvalidateWaitForStreamRunningInterval()
        
    }
    
    func ResetAllFlagVariable() {
        //set flag back to false
        acceptCallFlag = false
        endCallFlag = false
        incomingCallFlags = false
        IncomingCallController.IncomingCallFlag = false
        IncomingCallController.CallToAction = false
        callStreamRunning = false
        
        //invalidate set up call in progress interval
        IncomingCallController.InvalidateSetUpCallInProgressInterval()
        
        //invalidate wait for stream running interval
        IncomingCallController.InvalidateWaitForStreamRunningInterval()
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        acceptCallFlag = true
    }
    
    func AcceptCallAction() {
        LinphoneManager.receiveCall()
        incomingCallFlags = false
    }
    
    func EndCallAction() {
        LinphoneManager.endCall()
        incomingCallFlags = false
        releaseCallFlag = true
        //Report to end the last call for CallKit
        callKitManager?.end(uuid: lastCallUUID)
        
        //reset all flag
        ResetAllFlagVariable()
    }
    
    func PrepareInCallProgressUI() {
        //        callStreamRunning = false
        answerCallBtn.isHidden = true
        rejectCallBtn.isHidden = true
        endCallBtn.isHidden = false
        speakerBtn.isHidden = false
        speakerLabel.isHidden = false
        muteBtn.isHidden = false
        muteLabel.isHidden = false
        
        callingDurationLabel.text = "00:00"
        
        //set interval to update call duration label
        if IncomingCallController.setUpCallInProgressInterval == nil {
            IncomingCallController.setUpCallInProgressInterval = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(IncomingCallController.SetUpCallInProgress), userInfo: nil, repeats: true)
        }
        
        print("PrepareInCallProgressUI ========")
    }
    
    @IBAction func MuteBtnClicked(_ sender: Any) {
        if muteLabel.text == "Mute" {
            MuteCallAction()
        } else {
            UnmuteCallAction()
        }
    }
    
    func MuteCallAction() {
        LinphoneManager.muteMic()
        muteLabel.text = "Unmute"
        muteBtn.tintColor = UIColor.black
        muteBtn.backgroundColor = UIColor.white
    }
    
    func UnmuteCallAction() {
        LinphoneManager.unmuteMic()
        muteLabel.text = "Mute"
        muteBtn.tintColor = UIColor.white
        muteBtn.backgroundColor = UIColor.clear
    }
    
    @IBAction func SpeakerBtnClicked(_ sender: Any) {
        if speakerBtn.tag == 0 {
            EnableLoudSpeakerAction()
        } else {
            DisableLoudSpeakerAction()
        }
    }
    
    func EnableLoudSpeakerAction() {
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        speakerBtn.tag = 1
        speakerBtn.tintColor = UIColor.black
        speakerBtn.backgroundColor = UIColor.white
    }
    
    func DisableLoudSpeakerAction() {
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.none)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        speakerBtn.tag = 0
        speakerBtn.tintColor = UIColor.white
        speakerBtn.backgroundColor = UIColor.clear
    }
    
    func SetUpCallInProgress() {
        let (hour, minute, second) = LinphoneManager.getCurrentCallDuration()
        //convert it to have 2 digits number
        let secondStr = second < 10 ? "0" + String(second) : String(second)
        let minuteStr = minute < 10 ? "0" + String(minute) : String(minute)
        let hourStr = hour < 10 ? "0" + String(hour) : String(hour)
        
        //initialize call duration into calling label, condition show hours value only when it reaches an hour
        callingDurationLabel.text = hour == 0 ? minuteStr + ":" + secondStr : hourStr + ":" + minuteStr + ":" + secondStr
        
        if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            //store active call duration
            callDuration = hour == 0 ? minuteStr + ":" + secondStr : hourStr + ":" + minuteStr + ":" + secondStr
        }
        
        if IncomingCallController.EndCallFlag == true {
            //when user ends call
            EndCallAction()
        }
        
        print("setUpCallInProgressInterval?.invalidate() -------- ", LinphoneManager.interuptedCallFlag)
        
        //remove interval when A accept the call and B end the call
        if LinphoneManager.CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            print(callDuration, "--- STH")
            //Set call duration when call is dropped
            SetCallDurationToCoreData()
            //invalidate set up call in progress interval
            IncomingCallController.InvalidateSetUpCallInProgressInterval()
        }
        
        print(LinphoneManager.CheckLinphoneCallState(), "===OKAY===")
    }
    
    static func InvalidateWaitForStreamRunningInterval() {
        //invalidate wait for stream running interval
        if IncomingCallController.waitForStreamRunningInterval != nil {
            IncomingCallController.waitForStreamRunningInterval?.invalidate()
            IncomingCallController.waitForStreamRunningInterval = nil
        }
    }
    
    static func InvalidateSetUpCallInProgressInterval() {
        //invalidate set up call in progress interval
        if IncomingCallController.setUpCallInProgressInterval != nil {
            IncomingCallController.setUpCallInProgressInterval?.invalidate()
            IncomingCallController.setUpCallInProgressInterval = nil
        }
    }
    
    func PresentIncomingVC() {
        userCoreDataInstance.StoreCallDataLog(_callerID: IncomingCallController.CallToAction == true ? IncomingCallController.dialPhoneNumber : LinphoneManager.getCallerNb(), _callerName: IncomingCallController.CallToAction == true ? "" : LinphoneManager.getContactName(), _callDuration: callDuration, _callIndicatorIcon: IncomingCallController.CallToAction == true ? "outgoing-call-icon" : "incoming-call-icon")
        print("--- SAVED", IncomingCallController.dialPhoneNumber)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IncomingCallSB") as! IncomingCallController
        UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
    }
    
    func SetImageBtn(button: UIButton, imageName: String, imgEdgeInsets: CGFloat) {
        if #available(iOS 11, *) {
            button.setImage(UIImage(named: imageName), for: .normal)
            button.contentMode = .center
            button.imageView?.contentMode = .scaleAspectFit
            switch imageName{
            case "speaker-icon":
                button.imageEdgeInsets =  UIEdgeInsets(top: imgEdgeInsets, left: imgEdgeInsets, bottom: imgEdgeInsets, right: -40 )
                break
            case "mute-icon":
                button.imageEdgeInsets =  UIEdgeInsets(top: imgEdgeInsets, left: imgEdgeInsets, bottom: imgEdgeInsets, right: -15 )
                break
            default:
                button.imageEdgeInsets =  UIEdgeInsets(top: imgEdgeInsets, left: imgEdgeInsets, bottom: imgEdgeInsets, right: imgEdgeInsets)
                break
            }
            button.setTitle("", for: .normal)
            
        } else{
            button.setImage(UIImage(named: imageName), for: .normal)
            button.contentMode = .center
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsetsMake(imgEdgeInsets, imgEdgeInsets, imgEdgeInsets, imgEdgeInsets)
            
            
        }
        
    }
}

