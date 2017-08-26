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
import CallKit

var waitForStreamRunningInterval: Timer?

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
    static var callLogTime = ""
    var callLogData = [SipCallData]()
    var callDataRequest: NSFetchRequest<SipCallData> = SipCallData.fetchRequest()
    let userCoreDataInstance = UserProfileCoreData()
    var callKitManager: CallKitCallInit?
    let callController = CXCallController()
    
    static var dialPhoneNumber: String = ""
    var setUpCallInProgressInterval: Timer?
    
    static var IncomingCallFlag = false
    var incomingCallFlags = false {
        didSet {
            
            //listen for incoming call event
            if incomingCallFlags == true {
                IncomingCallController.IncomingCallFlag = incomingCallFlags
                print(IncomingCallController.IncomingCallFlag, "----1variable")
                
                IncomingCallController.CallToAction = false
                PresentIncomingVC()
                
                //stop AVAudioPlayer background task while about to call
                BackgroundTask.backgroundTaskInstance.stopBackgroundTask()
                
                let appState = UIApplication.shared.applicationState
                if appState == .background {
                    DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
                        //Display CallKit for iOS 10
                        if #available(iOS 10, *) {
                            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: LinphoneManager.getContactName()) { _ in
                                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                            }
                        //Display local notification alert for non-callkit supported device
                        } else {
                            // ios 9
                            let notification = UILocalNotification()
                            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                            notification.alertBody = "Incoming Call"
                            notification.alertAction = LinphoneManager.getContactName() + " is calling"
                            notification.soundName = UILocalNotificationDefaultSoundName
                            UIApplication.shared.scheduleLocalNotification(notification)
                        }
                    }
                }
                
            }
        }
    }
    
    static var CallToAction = false
    var callToFlag = false {
        didSet {
            print(callToFlag ,"+++++")
            
            if callToFlag == true {
                print("-----", IncomingCallController.IncomingCallFlag ,"+++++")
                if IncomingCallController.IncomingCallFlag == false {
                    IncomingCallController.CallToAction = true
                    
                    PresentIncomingVC()
                    
                    print("-------CALLTO_BEING_FREE_NOT_WITH_SOMEONE_ELSE--------")
                    
                    //stop AVAudioPlayer background task while about to call
                    BackgroundTask.backgroundTaskInstance.stopBackgroundTask()
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
            print("callStreamRunning ====YAYY====")
            
        }
    }
    
    static var AcceptCallFlag = false
    var acceptCallFlag = false {
        didSet {
            IncomingCallController.AcceptCallFlag = acceptCallFlag
            print("AcceptedCallStream ====YAYY====")
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
            //listen for release call event and dismiss the incoming call view
            if releaseCallFlag == true {
                IncomingCallController.CallStreamRunning = false
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                
                //reset all flag
                ResetAllFlagVariable()
                
                //report to CallKit that call is ended
                let endCallAction = CXEndCallAction(call: lastCallUUID)
                let callTransaction = CXTransaction(action: endCallAction)
                callController.request(callTransaction, completion: {(data) in })

                print("RELEASE, SET CALL DURATION---")
                
                //Linephone call will destory the audio session when the call ends, so wait for 5seconds to restart the AVAudioPlayer background task
                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(WaitToStartBackgroundTask), userInfo: nil, repeats: false)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callKitManager = CallKitCallInit(uuid: UUID(), handle: "")
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        callDataRequest = SipCallData.fetchRequest()
        do {
            callLogData = try manageObjectContext.fetch(callDataRequest)
        } catch {
            print("CAN\'T FETCH CALLLOGDATA \(error.localizedDescription) ===")
        }

        //Set all image buttons
        SetImageBtn(button: speakerBtn, imageName: "speaker-icon", imgEdgeInsets: 25)
        SetImageBtn(button: muteBtn, imageName: "mute-icon", imgEdgeInsets: 25)
        SetImageBtn(button: rejectCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        SetImageBtn(button: answerCallBtn, imageName: "call-answer", imgEdgeInsets: 13)
        SetImageBtn(button: endCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        
        //Interval waiting for callstream running, invalidate while call is in progress
        waitForStreamRunningInterval = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(IncomingCallController.WaitForStreamRunning), userInfo: nil, repeats: true)
        
        if IncomingCallController.CallToAction {
            //User makes call to other person
            PrepareCallToActionUI()
            
        } else {
            //User receives call, set contact name & caller number label for incoming call VC
            callerNameLabel.text = LinphoneManager.getContactName()
            callerIDLabel.text = LinphoneManager.getCallerNb()
            
        }
        
    }
    
    func WaitToStartBackgroundTask() {
        BackgroundTask.backgroundTaskInstance.startBackgroundTask()
    }
    
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
            waitForStreamRunningInterval?.invalidate()
            
            //stop the outGoingCallSound while in call progress
            if outGoingCallPlayer.isPlaying {
                outGoingCallPlayer.stop()
            }
            
            print("waitForStreamRunningInterval ========")
            
            PrepareInCallProgressUI()
        }
        
        //LinphoneCallError occurred
        if LinphoneManager.CheckLinphoneConnectionStatus() == false {
            waitForStreamRunningInterval?.invalidate()
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
        if LinphoneManager.CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            //decline call
            LinphoneManager.endCall()
            incomingCallFlags = false
            releaseCallFlag = true
            print(LinphoneManager.CheckLinphoneCallState(), "JONGMER==")
            waitForStreamRunningInterval?.invalidate()
        } else if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            IncomingCallController.EndCallFlag = true
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
        waitForStreamRunningInterval?.invalidate()
        
        //reset all flag
        ResetAllFlagVariable()
    }
    
    func ResetAllFlagVariable() {
        //set flag back to false
        acceptCallFlag = false
        endCallFlag = false
        incomingCallFlags = false
        IncomingCallController.IncomingCallFlag = false
        IncomingCallController.CallToAction = false
        callStreamRunning = false
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        IncomingCallController.AcceptCallFlag = true
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
        callStreamRunning = false
        
        answerCallBtn.isHidden = true
        rejectCallBtn.isHidden = true
        endCallBtn.isHidden = false
        speakerBtn.isHidden = false
        speakerLabel.isHidden = false
        muteBtn.isHidden = false
        muteLabel.isHidden = false
        
        callingDurationLabel.text = "00:00"
        //set interval to update call duration label
        setUpCallInProgressInterval = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(IncomingCallController.SetUpCallInProgress), userInfo: nil, repeats: true)
        
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
            
            setUpCallInProgressInterval?.invalidate()
            
        }

        print(LinphoneManager.CheckLinphoneCallState(), "===OKAY===")
    }
    
    func PresentIncomingVC() {
        userCoreDataInstance.StoreCallDataLog(_callerID: IncomingCallController.CallToAction == true ? IncomingCallController.dialPhoneNumber : LinphoneManager.getCallerNb(), _callerName: IncomingCallController.CallToAction == true ? "" : LinphoneManager.getContactName(), _callDuration: callDuration, _callIndicatorIcon: IncomingCallController.CallToAction == true ? "outgoing-call-icon" : "incoming-call-icon")
        
        print("--- SAVED", IncomingCallController.dialPhoneNumber)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IncomingCallSB") as! IncomingCallController
        
        UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
    }
    
    func SetImageBtn(button: UIButton, imageName: String, imgEdgeInsets: CGFloat) {
        button.setImage(UIImage(named: imageName), for: .normal)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(imgEdgeInsets, imgEdgeInsets, imgEdgeInsets, imgEdgeInsets)
    }
}
