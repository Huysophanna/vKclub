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
    var callDuration = ""
    static var callLogTime = ""
    var callLogData = [SipCallData]()
    var callDataRequest: NSFetchRequest<SipCallData> = SipCallData.fetchRequest()
    let personService = PersonService()
    
    static var dialPhoneNumber: String = ""
    var updateCallDurationInterval: Timer?
    var waitForStreamRunningInterval: Timer?
    var incomingCallFlags = false {
        didSet {
            //listen for incoming call event
            if incomingCallFlags == true {
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
                
                print("RELEASE, SET CALL DURATION---")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
//    func SaveCallLogDataToCoreData(_callIndicatorIcon: String, _callerName: String, _callerID: String) {
//        if _callIndicatorIcon != "" && _callerID != "" {
//            //Save call log data for recents section to coredata
//            let callLogCoreData = SipCallData(context: manageObjectContext)
//            callLogCoreData.callerID = _callerID
//            
//            callLogCoreData.callerName = _callerName
//            callLogCoreData.callIndicatorIcon = _callIndicatorIcon
//            
//            callLogCoreData.callDuration = callDuration
//            let (year, month, date, hour, min, sec) = UIComponentHelper.GetTodayString()
//            callLogCoreData.timeStamp = "\(hour):\(min)"
//            callLogCoreData.callLogTime = "\(year)-\(month)-\(date)-\(hour)-\(min)-\(sec)"
//            
//            //Used to check and update duration into the this particular call log
//            IncomingCallController.callLogTime = callLogCoreData.callLogTime!
//            
//            print("STH HAPPENN ", IncomingCallController.callLogTime)
//            
//            do {
//                try manageObjectContext.save()
//            } catch {
//                print ("Saving to CoreData error \(error.localizedDescription) ===")
//            }
//
//        }
//        
//    }
    
    func SetCallDurationToCoreData() {
        for _callData in callLogData {
            if _callData.callLogTime != nil {
                if _callData.callLogTime! == IncomingCallController.callLogTime {
                    let callDataItemToUpdate = personService.getCallDataByID(_id: _callData.objectID)
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
        
        incomingCallFlags = false
        releaseCallFlag = true
        
    }
    
    @IBAction func DeclineCallBtnClicked(_ sender: Any) {
        LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
        
        incomingCallFlags = false
        releaseCallFlag = true
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        LinphoneManager.receiveCall()
        
        incomingCallFlags = false
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
        
        if CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            //store active call duration
            callDuration = hour == 0 ? minuteStr + ":" + secondStr : hourStr + ":" + minuteStr + ":" + secondStr
        }
        
        //remove interval when A accept the call and B end the call
        if CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            print(callDuration, "--- STH")
            
            //Set call duration when call is dropped
            SetCallDurationToCoreData()
            
            updateCallDurationInterval?.invalidate()
        }
        
        print(callState, "======")
    }
    
    
    func PresentIncomingVC() {
//        SaveCallLogDataToCoreData(_callIndicatorIcon: IncomingCallController.CallToAction == true ? "outgoing-call-icon" : "incoming-call-icon" , _callerName: IncomingCallController.CallToAction == true ? "" : LinphoneManager.getContactName(), _callerID: IncomingCallController.CallToAction == true ? IncomingCallController.dialPhoneNumber : LinphoneManager.getCallerNb())
//        
        personService.StoreCallDataLog(_callerID: IncomingCallController.CallToAction == true ? IncomingCallController.dialPhoneNumber : LinphoneManager.getCallerNb(), _callerName: IncomingCallController.CallToAction == true ? "" : LinphoneManager.getContactName(), _callDuration: callDuration, _callIndicatorIcon: IncomingCallController.CallToAction == true ? "outgoing-call-icon" : "incoming-call-icon")
        
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
