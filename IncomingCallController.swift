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
    @IBOutlet weak var rejectCallBtn: UIButton!
    @IBOutlet weak var answerCallBtn: UIButton!
    
    var incomingCallFlag = false {
        didSet {
            //listen for incoming call event
            if (incomingCallFlag == true) {
                PresentIncomingVC()
            } else {
                self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func DeclineCallBtnClicked(_ sender: Any) {
        LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
        incomingCallFlag = false
        
    }
    
    @IBAction func AcceptCallBtnClicked(_ sender: Any) {
        LinphoneManager.receiveCall()
        incomingCallFlag = false
        
        print(LinphoneManager.getCallerNb());
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
        
    }

    
}
