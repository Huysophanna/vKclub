import Foundation
import AVFoundation
import CoreData
import Firebase

var answerCall: Bool = false
let LINPHONE_CALLSTREAM_RUNNING = "LinphoneCallStreamsRunning"
let LINPHONE_CALL_ERROR = "LinphoneCallError"
let LINPHONE_CALL_OUTGOING_RINGING = "LinphoneCallOutgoingRinging"
let LINPHONE_CALL_OUTGOING_EARLY_MEDIA = "LinphoneCallOutgoingEarlyMedia"
let LINPHONE_CALL_IDLE = "LinphoneCallIdle"

var outGoingCallPlayer = AVAudioPlayer()
var proxyConfig: OpaquePointer? = nil
var userAuthInfo: OpaquePointer? = nil

struct theLinphone {
    static var lc: OpaquePointer?
    static var lct: LinphoneCoreVTable?
    static var manager: LinphoneManager?
}

let registrationStateChanged: LinphoneCoreRegistrationStateChangedCb  = {
    (lc: Optional<OpaquePointer>, proxyConfig: Optional<OpaquePointer>, state: _LinphoneRegistrationState, message: Optional<UnsafePointer<Int8>>) in
    
    switch state {
        
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        if LinphoneConnectionStatusFlag == false {
            UIComponentHelper.scheduleNotification(_title: "PhoneCall Registered", _body: "You are not connected. Please connect to our wifi network to recieve and make call.", _inSeconds:0.1)
            connection = false
            LinphoneConnectionStatusFlag = true
        }
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
    case LinphoneRegistrationOk:
        connection = true
        if LinphoneConnectionStatusFlag {
            if iflogOut || linphoneInit == "logout"{
                return
            }
            NSLog("LinphoneRegistrationOk")
            getExtensionSucc = "Extension"
            
            UIComponentHelper.scheduleNotification(_title: "PhoneCall Registered", _body: "You are connected. Available to recieve and make call.", _inSeconds:0.1)
            LinphoneConnectionStatusFlag = false
        }
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        LinphoneConnectionStatusFlag = true
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
    default:
        print(state,"state++++")
        NSLog("Unkown registration state")
    }
    } as LinphoneCoreRegistrationStateChangedCb

let callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: Optional<OpaquePointer>, call: Optional<OpaquePointer>, callSate: LinphoneCallState,  message:     Optional<UnsafePointer<Int8>>) in
    print(LinphoneManager.interuptedCallFlag ,"----ACTIVECALLFLAG")
    
    //    if LinphoneManager.onActiveCallFlag == false {
    //store call data as optional value for using in some other classes
    LinphoneManager.callOpaquePointerData = call
    LinphoneManager.lcOpaquePointerData = lc
    
    if LinphoneManager.mainCallOpaquePointerData == nil {
        LinphoneManager.mainCallOpaquePointerData = call
        LinphoneManager.mainLcOpaquePointerData = lc
    }
    //    }
    switch callSate {
        
    case LinphoneCallIncomingReceived: /**<This is a new incoming call */
        print("callStateChanged: LinphoneCallIncomingReceived", "====")
        if iflogOut {
            LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
            return
        }
        if IncomingCallController.CallToAction == false && IncomingCallController.IncomingCallFlag == false && LinphoneManager.interuptedCallFlag == false {
                
                
                print(IncomingCallController.CallToAction, IncomingCallController.IncomingCallFlag, LinphoneManager.interuptedCallFlag, "----3variables----")
                //indicates that there is an incoming call to show incomingcall screen
                incomingCallInstance.incomingCallFlags = true
                print("-------BEING_FREE_NOT_WITH_SOMEONE_ELSE--------")
            } else  {
                print(IncomingCallController.CallToAction, IncomingCallController.IncomingCallFlag, LinphoneManager.interuptedCallFlag, "----3variables----")
                //if user is already on active call with some other, will decline all incoming call
                LinphoneManager.interuptedCallFlag = true
                LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
                
                //when declined the call, it calls release flag, so have to check on that
                print("--------BEING_BUSY_WITH_SOMEONE_ELSE--------")
        }
       
        
        if answerCall {
            ms_usleep(3 * 1000 * 1000); // Wait 3 seconds to pickup
            linphone_core_accept_call(lc, call)
        }
        break
    case LinphoneCallStreamsRunning: /**<The media streams are established and running*/
        print("callStateChanged: LinphoneCallStreamsRunning", "====")
        LinphoneManager.callStreamRunning = true
        
        break
        
    case LinphoneCallError: /**<The call encountered an error*/
        print("callStateChanged: LinphoneCallError", "====")
        break
        
    case LinphoneCallReleased:
        LinphoneManager.callStreamRunning = false
        if LinphoneManager.interuptedCallFlag == false {
            //if user is onActiveCall, will decline the call and will not release the active call view
            LinphoneManager.releaseCallFlag = true
            //set tempCallOpaquePointerData to nil back, since call is over
            LinphoneManager.mainCallOpaquePointerData = nil
            LinphoneManager.mainLcOpaquePointerData = nil
            
            print("callStateChanged: LinphoneCallReleased", "====")
            print("------BEING_FREE_NOT_WITH_SOMEONE_ELSE_RELEASE_STATE--------")
        } else {
            print("------BEING_BUSY_WITH_SOMEONE_ELSE_RELEASE_STATE--------")
            
            //compare current callOpaquePointer with tempCallOpaquePointer
            //if true means, this release call is fired for the 1st call
            if LinphoneManager.callOpaquePointerData == LinphoneManager.mainCallOpaquePointerData {
                //set onActiveCallFlag back to false
                LinphoneManager.interuptedCallFlag = false
                //set tempCallOpaquePointerData to nil back, since call is over
                LinphoneManager.mainCallOpaquePointerData = nil
                LinphoneManager.mainLcOpaquePointerData = nil
                
                //this is the 1st call, so we can release the call flag
                LinphoneManager.releaseCallFlag = true
                
                print("callOpaquePointer ===== --------")
            } else {
                //this is not the 1st call that we care about, some other is trying to call concurrently
                //so do not release the call, and assign the tempCallOpaquePointerCall from the 1st call
                //to the current callOpaquePointerData
                //assign the first calling tempCallOpaquePointerData to new callOpaquePointerData
                LinphoneManager.callOpaquePointerData = LinphoneManager.mainCallOpaquePointerData
                LinphoneManager.lcOpaquePointerData = LinphoneManager.mainLcOpaquePointerData
                
                print("callOpaquePointer !!!!!! --------")
            }
            
        }
        
        break
        
    case LinphoneCallOutgoingRinging:
        //play outGoingCallSound for callToAction
        outGoingCallPlayer.prepareToPlay()
        outGoingCallPlayer.play()
        break
        
    default:
        print(LinphoneManager.CheckLinphoneCallState(), "callStateChanged: Default", "====")
        
        if LinphoneManager.CheckLinphoneCallState() == "undefined" {
            LinphoneManager.interuptedCallFlag = false
            IncomingCallController.IncomingCallFlag = false
            IncomingCallController.CallToAction = false
        }
        
        break
    }
}

class LinphoneManager {
    static let incomingCallInstance = IncomingCallController()
    static var linphoneCallStatus: String = ""
    static var interuptedCallFlag: Bool = false
    static var callOpaquePointerData: Optional<OpaquePointer>
    static var lcOpaquePointerData: Optional<OpaquePointer>
    static var mainCallOpaquePointerData: Optional<OpaquePointer>
    static var mainLcOpaquePointerData: Optional<OpaquePointer>
    static var incomingCallFlag: Bool = false {
        didSet {
            print(LinphoneManager.callOpaquePointerData as Any ,"----START")
            incomingCallInstance.incomingCallFlags = incomingCallFlag
        }
    }
    
    static var callStreamRunning: Bool = false {
        didSet {
            incomingCallInstance.callStreamRunning = callStreamRunning
        }
    }
    static var releaseCallFlag: Bool = true {
        //send true when release call to dismiss incoming view, then set it back false
        willSet {
            incomingCallInstance.releaseCallFlag = releaseCallFlag
        }
        didSet {
            incomingCallInstance.releaseCallFlag = false
        }
    }
    
    static var iterateTimer: Timer?
    static var shutDownFlag = false
    var extension_ids = [Extension]()
    
    static var userAuthInfoAddedFlag = UserDefaults.standard.bool(forKey: "userAuthInfoAddedFlag")
    
    init() {
        theLinphone.lct = LinphoneCoreVTable()
        // Enable debug log to stdout
        linphone_core_set_log_file(nil)
        linphone_core_set_log_level(ORTP_DEBUG)
        
        // Load config
        let configFilename = documentFile("linphonerc222")
        let factoryConfigFilename = bundleFile("linphonerc-factory")
        
        let configFilenamePtr: UnsafePointer<Int8> = configFilename.cString(using: String.Encoding.utf8.rawValue)!
        let factoryConfigFilenamePtr: UnsafePointer<Int8> = factoryConfigFilename.cString(using: String.Encoding.utf8.rawValue)!
        let lpConfig = lp_config_new_with_factory(configFilenamePtr, factoryConfigFilenamePtr)
        
        // Set Callback
        theLinphone.lct?.registration_state_changed = registrationStateChanged
        theLinphone.lct?.call_state_changed = callStateChanged
        
        theLinphone.lc = linphone_core_new_with_config(&theLinphone.lct!, lpConfig, nil)
        
        // Set ring asset
        let ringbackPath = URL(fileURLWithPath: Bundle.main.bundlePath).appendingPathComponent("/ringback.wav").absoluteString
        linphone_core_set_ringback(theLinphone.lc, ringbackPath)
        
        let localRing = URL(fileURLWithPath: Bundle.main.bundlePath).appendingPathComponent("/toy-mono.wav").absoluteString
        linphone_core_set_ring(theLinphone.lc, localRing)
        
        // Set outGoingCall ring asset
        do {
            let callToSoundBundle = Bundle.main.path(forResource: "OutGoingCallSound", ofType: "wav")
            let alertSound = URL(fileURLWithPath: callToSoundBundle!)
            try outGoingCallPlayer = AVAudioPlayer(contentsOf: alertSound)
        } catch {
            print("AVAudioPlayer Interrupted ===")
        }
        
        
        
    }
    
    fileprivate func bundleFile(_ file: NSString) -> NSString{
        return Bundle.main.path(forResource: file.deletingPathExtension, ofType: file.pathExtension)! as NSString
    }
    
    fileprivate func documentFile(_ file: NSString) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsPath: NSString = paths[0] as NSString
        return documentsPath.appendingPathComponent(file as String) as NSString
    }
    
    static func makeCall(phoneNumber: String) {
        
        if IncomingCallController.IncomingCallFlag == false {
            let calleeAccount = phoneNumber
            if theLinphone.lc != nil {
                linphone_core_invite(theLinphone.lc, calleeAccount)
            }
            
        } else {
            print("-------MAKECALL_BEING_BUSY_WITH_SOMEONE_ELSE--------")
        }
    }
    
    static func receiveCall() {
        linphone_core_accept_call(theLinphone.lc, LinphoneManager.callOpaquePointerData)
    }
    
    static func CheckLinphoneCallState() -> String {
        if LinphoneManager.callOpaquePointerData != nil {
            let callStateRawValue = linphone_call_state_to_string(linphone_call_get_state(LinphoneManager.callOpaquePointerData))
            let callState = String(cString: callStateRawValue!)
            linphoneCallStatus = callState
            
            return callState
        } else {
            return "ERROR"
        }
        
    }
    
    static func CheckLinphoneConnectionStatus() -> Bool {
        // 1 means registered
        if  connection {
            return true
        } else {
            return false
        }
    }
    
    static func muteMic() {
        linphone_core_enable_mic(LinphoneManager.lcOpaquePointerData, 0)
        
    }
    
    static func unmuteMic() {
        linphone_core_enable_mic(LinphoneManager.lcOpaquePointerData, 255)
    }
    
    static func getCallerNb() -> String {
        let remoteAddr = linphone_address_as_string(linphone_call_get_remote_address(LinphoneManager.callOpaquePointerData))
        
        let remoteAddrStr:String? = String(cString: remoteAddr!)
        let delimiter = "\""
        let dividedRemodeAddrStr = remoteAddrStr?.components(separatedBy: delimiter)
        
        if let callerID = dividedRemodeAddrStr?[safe: 2]?.substring(to: (dividedRemodeAddrStr?[safe: 2]?.index((dividedRemodeAddrStr?[safe: 2]?.endIndex)!, offsetBy: -15))!).substring(from: (dividedRemodeAddrStr?[safe: 2]?.index((dividedRemodeAddrStr?[safe: 2])!.startIndex, offsetBy: 6))!) {
            return callerID
        } else {
            return ""
        }
    }
    
    static func getContactName() -> String {
        if LinphoneManager.callOpaquePointerData != nil {
            let remoteAddr = linphone_address_as_string(linphone_call_get_remote_address(LinphoneManager.callOpaquePointerData))
            let remoteAddrStr:String? = String(cString: remoteAddr!)
            let delimiter = "\""
            let dividedRemodeAddrStr = remoteAddrStr?.components(separatedBy: delimiter)
            
            if let contactName = dividedRemodeAddrStr?[safe: 1] {
                return contactName
            }
        }
        return ""
    }
    
    static func getCurrentCallDuration() -> (Int, Int, Int) {
        let duration = Int(linphone_core_get_current_call_duration(LinphoneManager.lcOpaquePointerData))
        let hour = duration / 3600
        let minute = (duration % 3600) / 60
        let second = (duration % 3600) % 60
        
        return (hour, minute, second)
    }
    
    static func declineCall(_declinedReason: _LinphoneReason) {
        linphone_core_decline_call(theLinphone.lc, LinphoneManager.callOpaquePointerData, _declinedReason)
        print(LinphoneManager.callOpaquePointerData as Any ,"----DECLINED")
    }
    
    static func endCall() {
        print(LinphoneManager.CheckLinphoneCallState(), LinphoneManager.CheckLinphoneCallState() != LINPHONE_CALL_IDLE, LinphoneManager.CheckLinphoneCallState() != "undefined", "===ENDCALL")
        if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING || LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALL_OUTGOING_RINGING || LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALL_OUTGOING_EARLY_MEDIA {
            linphone_core_terminate_call(LinphoneManager.lcOpaquePointerData, LinphoneManager.callOpaquePointerData)
            linphone_core_terminate_all_calls(LinphoneManager.lcOpaquePointerData)
            print(LinphoneManager.callOpaquePointerData as Any ,"----ENDED")
        }
        
    }
    
    func LinphoneInit() {
        if changeExtention || checkwhenappclose == "Login" {
            let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                proxyConfig = self.setIdentify(_account: linphoneInit)
                LinphoneManager.register(proxyConfig!)
                self.setTimer()
            }
        } else {
            let when = DispatchTime.now() + 2// change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                proxyConfig = self.setIdentify(_account: linphoneInit)
                LinphoneManager.register(proxyConfig!)
                self.setTimer()
            }
        }
        
    }
    
    func GetDataFromServer()  {
        var extentionids = ""
        let currentuser = Auth.auth().currentUser
        var request = URLRequest(url: URL(string:"http://192.168.7.251:8000/api/v.1/get-extension" )!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("wfvUd0d4Bw7RfeCqwEe4F0GWTL3dpzai7f7euYBuI", forHTTPHeaderField: "VKAPP-API-TOKEN")
        request.addValue((currentuser?.uid)!, forHTTPHeaderField: "VKAPP-USERID")
        request.addValue((currentuser?.displayName)!, forHTTPHeaderField: "VKAPP-USERNAME")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                getExtensionSucc = "getExtensionSucc"
                self.GetAccountExtension()
                
            } else {
                if let data = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        let code = json?["code"]
                        let code_check :Int =  code as! Int
                        switch code_check {
                        case 200 :
                            let newextension_id = NSEntityDescription.insertNewObject(forEntityName: "Extension", into: manageObjectContext)
                            let datas = json?["success"]  as! NSDictionary
                            let extensions  = datas["extension"] as! NSDictionary
                            if let extentionid = extensions.value(forKey: "extension"){
                                extentionids = String(describing: extentionid)
                                let token       = extensions.value(forKey: "token")
                                tokenExt_id  = token as! String
                                newextension_id.setValue(extentionids, forKey: "extension_id")
                                newextension_id.setValue(token , forKey: "token")
                                databaseRef.child("users").child((currentuser?.uid)!).child("Extension").setValue(extentionid)
                                databaseRef.child("users").child((currentuser?.uid)!).child("Token").setValue(token)
                                databaseRef.child("users").child((currentuser?.uid)!).child("Username").setValue(currentuser?.displayName)
                            }
                            do {
                                try  manageObjectContext.save()
                            } catch {
                                print("error")
                            }
                            
                            linphoneInit = String(describing: extentionids)
                            break
                        case 400 :
                            // out of scope make variable global
                            getExtensionSucc = "400"
                            self.GetDataFromServer()
                            
                            break
                        case 404 :
                            getExtensionSucc = "getExtensionSucc"
                            self.GetDataFromServer()
                            break
                            
                        default :
                            self.GetDataFromServer()
                            getExtensionSucc = String(code_check)
                            break
                            
                        }
                        
                    } catch {
                        print("error")
                    }
                    
                }
            }
            
        }
        task.resume()
        
    }
    
    func GetAccountExtension() {
        let extensionRequest:NSFetchRequest<Extension> = Extension.fetchRequest()
        do {
            extension_ids = try manageObjectContext.fetch(extensionRequest)
            if extension_ids == [] {
                let currentuser = Auth.auth().currentUser
                databaseRef.child("users").child((currentuser?.uid)!).observeSingleEvent(of: .value, with: { (data) in
                    // Get user value
                    if let datas = data.value as? NSDictionary  {
                        var extid = ""
                        var token = ""
                        if let exts = datas.value(forKey: "Extension") {
                            extid = String(describing: exts)
                            token = datas.value(forKey: "Token") as! String
                        }
                        
                        if extid.isEmpty || token.isEmpty {
                            self.GetDataFromServer()
                            return
                        }
                        else {
                            let newextension_id = NSEntityDescription.insertNewObject(forEntityName: "Extension", into: manageObjectContext)
                            newextension_id.setValue(extid, forKey: "extension_id")
                            newextension_id.setValue(token , forKey: "token")
                            do {
                                try  manageObjectContext.save()
                            } catch {
                                print("error")
                            }
                            
                            self.PostData(extensions : extid , tokenid:token )
                        }
                        
                        
                    } else {
                        self.GetDataFromServer()
                    }}) { (error) in
                        getExtensionSucc = "getExtensionSucc"
                }
            } else {
                
                for i in extension_ids {
                    if let ext =  i.extension_id {
                        self.PostData(extensions : ext , tokenid: i.token!)
                    }
                    
                }
            }
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    func UpdataExtensionLastRegister(extensions : String , tokenid: String){
        let currentuser = Auth.auth().currentUser
        var request = URLRequest(url: URL(string: "http://192.168.7.251:8000/api/v.1/trigger-extension")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("wfvUd0d4Bw7RfeCqwEe4F0GWTL3dpzai7f7euYBuI", forHTTPHeaderField: "VKAPP-API-TOKEN")
        request.addValue((currentuser?.uid)!, forHTTPHeaderField: "VKAPP-USERID")
        request.addValue((currentuser?.displayName)!, forHTTPHeaderField: "VKAPP-USERNAME")
        let parameters = ["ext":extensions , "reserved_token":tokenid ,"action": "register"]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                getExtensionSucc = "getExtensionSucc"
            }
        }
        
        task.resume()
        
        
    }
    func PostData(extensions : String , tokenid: String) {
        let currentuser = Auth.auth().currentUser
        var request = URLRequest(url: URL(string: "http://192.168.7.251:8000/api/v.1/trigger-extension")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("wfvUd0d4Bw7RfeCqwEe4F0GWTL3dpzai7f7euYBuI", forHTTPHeaderField: "VKAPP-API-TOKEN")
        request.addValue((currentuser?.uid)!, forHTTPHeaderField: "VKAPP-USERID")
        request.addValue((currentuser?.displayName)!, forHTTPHeaderField: "VKAPP-USERNAME")
        let parameters = ["ext":extensions , "reserved_token":tokenid ,"action": "register"]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                getExtensionSucc = "getExtensionSucc"
                self.GetAccountExtension()
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        if let code = json?["code"] {
                            let code_check = code as! Int
                            switch code_check {
                            case 200 :
                                linphoneInit = extensions
                                tokenExt_id  = tokenid
                                break
                            case 300 :
                                // code 300 mean  validate fail bc user api key had release
                                changeExtention  = true
                                InternetConnection.DeleteExtension()
                                InternetConnection.ShutdownPBXServer()
                                self.GetDataFromServer()
                                break
                            case 302 :
                                // code 300 mean  validate fail bc user api key had use
                                changeExtention  = true
                                InternetConnection.DeleteExtension()
                                InternetConnection.ShutdownPBXServer()
                                self.GetDataFromServer()
                                
                                break
                            default :
                                getExtensionSucc = String(code_check)
                                break
                                
                            }
                        }
                        
                    } catch {
                        self.GetAccountExtension()
                    }
                }
            }
            
        }
        task.resume()
        
        
        
    }
    
    func setIdentify(_account: String) -> OpaquePointer? {
        // Reference: http://www.linphone.org/docs/liblinphone/group__registration__tutorials.html
        
        //        let path = Bundle.main.path(forResource: "Secret", ofType: "plist")
        //        let dict = NSDictionary(contentsOfFile: path!)
        //        let account = dict?.object(forKey: "account") as! String
        //        let password = dict?.object(forKey: "password") as! String
        //        let domain = dict?.object(forKey: "domain") as! String
        
        let password = "A2apbx" + _account
        let domain = "192.168.7.251:5060"
        
        print(_account, password, "--++")
        
        let identity = "sip:" + _account + "@" + domain;
        
        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return nil
        }
        
        userAuthInfo = linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(theLinphone.lc!,userAuthInfo); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String(cString: linphone_address_get_domain(from)); /*extract domain address from identity*/
        linphone_address_destroy(from); /*release resource*/
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr); /* we assume domain = proxy server address*/
        //        linphone_proxy_config_enable_register(proxy_cfg, 0); /* activate registration for this proxy config*/
        linphone_proxy_config_set_expires(proxy_cfg, 60)
        linphone_core_add_proxy_config(theLinphone.lc!, proxy_cfg); /*add proxy config to linphone core*/
        linphone_core_set_default_proxy_config(theLinphone.lc!, proxy_cfg); /*set to default proxy*/
        LinphoneManager.enableRegistration()
        return proxy_cfg!
    }
    
    static func register(_ proxy_cfg: OpaquePointer) {
        linphone_proxy_config_enable_register(proxy_cfg, 1); /* activate registration for this proxy config*/
    }
    
    
    static func shutdown(){
        
        NSLog("Linphone unregister()..")
        if  TiemeVoip != nil {
            TiemeVoip?.invalidate()
            TiemeVoip = nil
        }
        
        LinphoneManager.shutDownFlag = true
        let proxy_cfg = linphone_core_get_default_proxy_config(theLinphone.lc); /* get default proxy config*/
        if linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationFailed {
            linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
            linphone_proxy_config_enable_publish(proxy_cfg, 1);
            linphone_proxy_config_set_publish_expires(proxy_cfg, 0);
            //linphone_core_set_network_reachable(proxy_cfg, 0)
            linphone_proxy_config_enable_register(proxy_cfg, 0); /*de-activate registration for this proxy config*/
            linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
            print(linphone_proxy_config_get_state(proxy_cfg),"+++proxy_cfg")
            print(LinphoneRegistrationCleared,"+++Cleared")
            while(linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationCleared) {
                linphone_core_iterate(theLinphone.lc); /*to make sure we receive call backs before shutting down*/
                ms_usleep(50000);
            }
//            linphone_proxy_config_destroy(proxyConfig)
            LinphoneManager.removeUserAuthInfo()
                   // linphone_core_destroy(theLinphone.lc);
            linphone_core_remove_proxy_config(theLinphone.lc, proxyConfig)
        }
        
    }
    
    static func enableRegistration(){
        NSLog("enableRegistration ---")
        LinphoneManager.shutDownFlag = false
        
        let proxy_cfg = linphone_core_get_default_proxy_config(theLinphone.lc); /* get default proxy config*/
        linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
        //        linphone_core_set_network_reachable(proxy_cfg, 1)
        linphone_proxy_config_enable_register(proxy_cfg, 1); /*activate registration for this proxy config*/
        linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
        
    }
    
    static func removeUserAuthInfo() {
        linphone_core_remove_auth_info(theLinphone.lc, userAuthInfo)
        linphone_auth_info_destroy(userAuthInfo)
    }
    
    @objc func iterate(){
        if LinphoneManager.shutDownFlag == false {
            if let lc = theLinphone.lc {
                //print(LinphoneManager.shutDownFlag,lc ,"+++")
                linphone_core_iterate(lc); /* first iterate initiates registration */
            }
            
        }
    }
    
    fileprivate func setTimer(){
        if TiemeVoip == nil {
            TiemeVoip = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(iterate), userInfo: nil, repeats: true)
        }
        
        
    }
    
    
}
