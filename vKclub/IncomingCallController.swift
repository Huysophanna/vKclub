//
//  IncomingCallController.swift
//  vKclub
//
//  Created by HuySophanna on 5/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import Foundation
import UIKit

class IncomingCallController: UIViewController {
    @IBOutlet weak var callerNameLabel: UILabel!
    @IBOutlet weak var callerIDLabel: UILabel!
    @IBOutlet weak var callingDurationLabel: UILabel!
    @IBOutlet weak var rejectCallBtn: UIButton!
    @IBOutlet weak var answerCallBtn: UIButton!
    @IBOutlet weak var endCallBtn: UIButton!
    
    var callStateRawValue: UnsafePointer<Int8>?
    var callState: String = ""
    
    var updateCallDurationInterval: Timer?
    var incomingCallFlag = false {
        didSet {
            //listen for incoming call event
            if (incomingCallFlag == true) {
                PresentIncomingVC()
            } else {
//                if callState != "LinphoneCallStreamsRunning" {
//                    UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
//                }
            }
        }
    }
    
    var releaseCallFlag = false {
        didSet {
            //listen for release call event and dismiss the incoming call view
            if (releaseCallFlag == true) {
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetImageBtn()
        
        callerNameLabel.text = LinphoneManager.getContactName()
        callerIDLabel.text = LinphoneManager.getCallerNb()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func EndCallBtnClicked(_ sender: Any) {
        LinphoneManager.endCall()
        incomingCallFlag = false
        
//        updateCallDurationInterval?.invalidate()

    }
    
    @IBAction func DeclineCallBtnClicked(_ sender: Any) {
        LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
        incomingCallFlag = false
        
//        updateCallDurationInterval?.invalidate()
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        LinphoneManager.receiveCall()
        incomingCallFlag = false
        
        answerCallBtn.isHidden = true
        rejectCallBtn.isHidden = true
        endCallBtn.isHidden = false
        
        callingDurationLabel.text = "00:00"
        //set interval to update call duration label
        updateCallDurationInterval = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(IncomingCallController.UpdateCallDuration), userInfo: nil, repeats: true)
    }
    
    func UpdateCallDuration() {
        //check linphone call state
        callStateRawValue = linphone_call_state_to_string(linphone_call_get_state(LinphoneManager.callOpaquePointerData))
        callState = String(cString: callStateRawValue!)
        
        let (hour, minute, second) = LinphoneManager.getCurrentCallDuration()
        //convert it to have 2 digits number
        let secondStr = second < 10 ? "0" + String(second) : String(second)
        let minuteStr = minute < 10 ? "0" + String(minute) : String(minute)
        let hourStr = hour < 10 ? "0" + String(hour) : String(hour)
        
        //initialize call duration into calling label, condition show hours value only when it reaches an hour
        callingDurationLabel.text = hour == 0 ? minuteStr + ":" + secondStr : hourStr + ":" + minuteStr + ":" + secondStr
        
        //remove interval when A accept the call and B end the call
        if callState != "LinphoneCallStreamsRunning" {
            updateCallDurationInterval?.invalidate()
        }
    }
    
    
    func PresentIncomingVC() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IncomingCallSB") as! IncomingCallController
        
        UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
        
    }
    
    func SetImageBtn() {
        
        rejectCallBtn.setImage(UIImage(named: "reject-phone-icon"), for: .normal)
        rejectCallBtn.contentMode = .center
        rejectCallBtn.imageView?.contentMode = .scaleAspectFit
        rejectCallBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        answerCallBtn.setImage(UIImage(named: "call-answer"), for: .normal)
        answerCallBtn.contentMode = .center
        answerCallBtn.imageView?.contentMode = .scaleAspectFit
        answerCallBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13)
        
        endCallBtn.setImage(UIImage(named: "reject-phone-icon"), for: .normal)
        endCallBtn.contentMode = .center
        endCallBtn.imageView?.contentMode = .scaleAspectFit
        endCallBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
    }

    
}
