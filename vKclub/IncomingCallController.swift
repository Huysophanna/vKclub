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
    
    let LINPHONE_CALLSTREAM_RUNNING = "LinphoneCallStreamsRunning"
    
    var callStateRawValue: UnsafePointer<Int8>?
    var callState: String = ""
    
    static var dialPhoneNumber: String = ""
    var updateCallDurationInterval: Timer?
    var waitForStreamRunningInterval: Timer?
    var incomingCallFlag = false {
        didSet {
            //listen for incoming call event
            if incomingCallFlag == true {
                IncomingCallController.CallToAction = false
                PresentIncomingVC()
                
            }
        }
    }
    
    static var CallToAction = false
    var callToFlag = false {
        didSet {
            if callToFlag == true {
                IncomingCallController.CallToAction = true
                PresentIncomingVC()
                
            }
        }
    }
    
    static var CallStreamRunning = false
    var callStreamRunning = false {
        didSet {
            IncomingCallController.CallStreamRunning = callStreamRunning
            print("callStreamRunning ====YAYY====")
        }
    }
    
    var releaseCallFlag = false {
        didSet {
            //listen for release call event and dismiss the incoming call view
            if releaseCallFlag == true {
                IncomingCallController.CallStreamRunning = false
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set all image buttons
        SetImageBtn(button: speakerBtn, imageName: "speaker-icon", imgEdgeInsets: 25)
        SetImageBtn(button: muteBtn, imageName: "mute-icon", imgEdgeInsets: 25)
        SetImageBtn(button: rejectCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        SetImageBtn(button: answerCallBtn, imageName: "call-answer", imgEdgeInsets: 13)
        SetImageBtn(button: endCallBtn, imageName: "reject-phone-icon", imgEdgeInsets: 5)
        
        if IncomingCallController.CallToAction {
            //User makes call to other person
            PrepareCallToActionUI()
            
            waitForStreamRunningInterval = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(IncomingCallController.WaitForStreamRunning), userInfo: nil, repeats: true)

            
        } else {
            //User receives call, set contact name & caller number label for incoming call VC
            callerNameLabel.text = LinphoneManager.getContactName()
            callerIDLabel.text = LinphoneManager.getCallerNb()
        }
        
    }
    
    func SaveCallLogDataToCoreData(_callIndicatorIcon: String, _callerName: String) {
        //Save call log data for recents section to coredata
        let callLogCoreData = SipCallData(context: manageObjectContext)
        callLogCoreData.callerID = IncomingCallController.dialPhoneNumber
        callLogCoreData.callerName = _callerName
        callLogCoreData.callIndicatorIcon = _callIndicatorIcon
        
        let (callDurationHour, callDurationMin, callDurationSec) = LinphoneManager.getCurrentCallDuration()
        callLogCoreData.callDuration = "\(callDurationHour):\(callDurationMin):\(callDurationSec)"
        let (year, month, date, hour, min, _) = UIComponentHelper.GetTodayString()
        callLogCoreData.timeStamp = "\(hour):\(min)"
        callLogCoreData.callLogTime = "\(year)-\(month)-\(date)-\(hour)-\(min)"
        
        do {
            try manageObjectContext.save()
        } catch {
            print ("Saving to CoreData error \(error.localizedDescription) ===")
        }
        
    }
    
    func WaitForStreamRunning() {
        if CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            waitForStreamRunningInterval?.invalidate()
            
            PrepareInCallProgressUI()
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
        print(CheckLinphoneCallState(), "====")
        LinphoneManager.endCall()
        
        print(IncomingCallController.CallToAction, "===CALLTOACTION")
        
        SaveCallLogDataToCoreData(_callIndicatorIcon: IncomingCallController.CallToAction == true ? "outgoing-call-icon" : "incoming-call-icon" , _callerName: IncomingCallController.CallToAction == true ? "" : LinphoneManager.getContactName())
        
        incomingCallFlag = false
        releaseCallFlag = true
        
        
        let callLogCoreData = SipCallData(context: manageObjectContext)
        print(callLogCoreData, "===PRINTCD=== \(String(describing: callLogCoreData.callIndicatorIcon)) \(String(describing: callLogCoreData.callerID))")
        
    }
    
    @IBAction func DeclineCallBtnClicked(_ sender: Any) {
        LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
        
        incomingCallFlag = false
        releaseCallFlag = true
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        LinphoneManager.receiveCall()
        
        incomingCallFlag = false
        PrepareInCallProgressUI()
    }
    
    func CheckLinphoneCallState() -> String {
        callStateRawValue = linphone_call_state_to_string(linphone_call_get_state(LinphoneManager.callOpaquePointerData))
        callState = String(cString: callStateRawValue!)
        return callState
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
        updateCallDurationInterval = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(IncomingCallController.UpdateCallDuration), userInfo: nil, repeats: true)
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
    
    func UpdateCallDuration() {
        let (hour, minute, second) = LinphoneManager.getCurrentCallDuration()
        //convert it to have 2 digits number
        let secondStr = second < 10 ? "0" + String(second) : String(second)
        let minuteStr = minute < 10 ? "0" + String(minute) : String(minute)
        let hourStr = hour < 10 ? "0" + String(hour) : String(hour)
        
        //initialize call duration into calling label, condition show hours value only when it reaches an hour
        callingDurationLabel.text = hour == 0 ? minuteStr + ":" + secondStr : hourStr + ":" + minuteStr + ":" + secondStr
        
        //remove interval when A accept the call and B end the call
        if CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            updateCallDurationInterval?.invalidate()
        }
        
        print(callState, "======")
    }
    
    
    func PresentIncomingVC() {
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
