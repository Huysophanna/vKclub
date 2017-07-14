//
//  RecentCallController.swift
//  vKclub
//
//  Created by HuySophanna on 13/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit

class RecentCallController: UIViewController {
    
    var incomingCallInstance = IncomingCallController()
    var currentCallLogBtnHeight = 0;
    var callLogBtnColor = "#218154"
    var switchCallLogBtnColor = false {
        didSet {
            if switchCallLogBtnColor == true {
                callLogBtnColor = "#539C64"
            } else {
                callLogBtnColor = "#218154"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        InstantiateCallLogListBtn(_btnIcon: "outgoing-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
        InstantiateCallLogListBtn(_btnIcon: "incoming-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
        InstantiateCallLogListBtn(_btnIcon: "outgoing-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
        InstantiateCallLogListBtn(_btnIcon: "incoming-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
        InstantiateCallLogListBtn(_btnIcon: "outgoing-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
        InstantiateCallLogListBtn(_btnIcon: "incoming-call-icon", _timeStampLabel: "10:00AM", _callerIDLabel: "10050", _callLogTimeLabel: "50 mins ago")
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func InstantiateCallLogListBtn(_btnIcon: String, _timeStampLabel: String, _callerIDLabel: String, _callLogTimeLabel: String) {
        //Init button
        let callListBtn = UIButton(frame: CGRect(x: 0, y: currentCallLogBtnHeight, width: Int(view.frame.width), height: Int(view.frame.height / 10)))
        callListBtn.backgroundColor = UIColor(hexString: self.callLogBtnColor, alpha: 1)
        callListBtn.addTarget(self, action: #selector(CallLogListBtnHandler), for: .touchUpInside)
        view.addSubview(callListBtn)
        currentCallLogBtnHeight += Int(view.frame.height / 10)
        
        //Switch button color
        self.switchCallLogBtnColor = !self.switchCallLogBtnColor
        
        //Make button border
        let lineView = UIView(frame: CGRect(x: 0, y: Int(callListBtn.frame.height - 1), width: Int(callListBtn.frame.width), height: 1))
        lineView.backgroundColor = UIColor.white
        callListBtn.addSubview(lineView)
        
        //Add call indicator left-icon
        let imageView = UIImageView();
        let image = UIImage(named: _btnIcon);
        imageView.image = image;
        imageView.frame = CGRect(x: Int(callListBtn.frame.height / 3), y: Int(callListBtn.frame.height / 3), width: Int(callListBtn.frame.height / 2.5), height: Int(callListBtn.frame.height / 2.5))
        callListBtn.addSubview(imageView)
        
        //Add top timestamp label and duration
        let timeStampLabelXPosition = (Int((callListBtn.frame.height / 3) * 2)) + Int(imageView.frame.width)
        let timeStampLabelYPosition = Int((callListBtn.frame.height / 3) / 2)
        let timeStampLabel = UILabel(frame: CGRect(x: timeStampLabelXPosition, y: timeStampLabelYPosition, width: Int(view.frame.width), height: Int(callListBtn.frame.height / 3)))
        timeStampLabel.text = _timeStampLabel
        timeStampLabel.textColor = UIColor.white
        callListBtn.addSubview(timeStampLabel)
        
        //Add caller-ID label
        let callerIDLabel = UILabel(frame: CGRect(x: timeStampLabelXPosition, y: Int(imageView.frame.height * 1.3), width: Int(view.frame.width), height: Int(imageView.frame.height * 80/100)))
        callerIDLabel.text = _callerIDLabel
        callerIDLabel.textColor = UIColor.white
        callerIDLabel.font = callerIDLabel.font.withSize(imageView.frame.height * 80/100)
        callListBtn.addSubview(callerIDLabel)
        
        //Add call log time label
        let callLogTimeLabel = UILabel(frame: CGRect(x: timeStampLabelXPosition, y: Int(imageView.frame.height * 1.3), width: Int(view.frame.width) - timeStampLabelXPosition - 5, height: Int(imageView.frame.height * 80/100)))
        callLogTimeLabel.text = _callLogTimeLabel
        callLogTimeLabel.textColor = UIColor.white
        callLogTimeLabel.textAlignment = .right
//        callLogTimeLabel.font = callerIDLabel.font.withSize(imageView.frame.height * 80/100)
        
        callListBtn.addSubview(callLogTimeLabel)
    }
    
    func CallLogListBtnHandler(senderBtn: UIButton) {
        
        //animate button on click
        UIView.animate(withDuration: 0.1, animations: {
            senderBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { animationFinished in
            UIView.animate(withDuration: 0.1, animations: {
                senderBtn.transform = CGAffineTransform.identity
            })
            
        })
        
        PresentActionSheet(_phoneNumber: "10050")
        
        print("\(senderBtn) You TOUCHED me! ===")
    }
    
    func PresentActionSheet(_phoneNumber: String) {
        let actionSheet = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        let cancelBtnHandler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let dialBtnHandler = UIAlertAction(title: "Dial", style: .default, handler: {(action) -> Void in
            LinphoneManager.makeCall(phoneNumber: _phoneNumber)
            IncomingCallController.dialPhoneNumber = _phoneNumber
            self.incomingCallInstance.callToFlag = true
        
        })
        
        actionSheet.addAction(dialBtnHandler)
        actionSheet.addAction(cancelBtnHandler)
        self.present(actionSheet, animated: true)
    }
    
    
}
