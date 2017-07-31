import Foundation

var answerCall: Bool = false
let LINPHONE_CALLSTREAM_RUNNING = "LinphoneCallStreamsRunning"
let LINPHONE_CALL_ERROR = "LinphoneCallError"


var proxyConfig: OpaquePointer? = nil

struct theLinphone {
    static var lc: OpaquePointer?
    static var lct: LinphoneCoreVTable?
    static var manager: LinphoneManager?
}

let registrationStateChanged: LinphoneCoreRegistrationStateChangedCb  = {
    (lc: Optional<OpaquePointer>, proxyConfig: Optional<OpaquePointer>, state: _LinphoneRegistrationState, message: Optional<UnsafePointer<Int8>>) in
    
    switch state{
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        NSLog("LinphoneRegistrationNone")
        
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
        
    case LinphoneRegistrationOk:
        NSLog("LinphoneRegistrationOk")
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
        
    default:
        NSLog("Unkown registration state")
    }
} as LinphoneCoreRegistrationStateChangedCb

let callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: Optional<OpaquePointer>, call: Optional<OpaquePointer>, callSate: LinphoneCallState,  message: Optional<UnsafePointer<Int8>>) in
    
    //store call data as optional value for using in some other classes
    LinphoneManager.callOpaquePointerData = call
    LinphoneManager.lcOpaquePointerData = lc
    
    switch callSate {
        case LinphoneCallIncomingReceived: /**<This is a new incoming call */
            print("callStateChanged: LinphoneCallIncomingReceived", "====")
        
            //indicate that there is an incoming call to show incomingcall screen
            LinphoneManager.incomingCallFlag = true
       
            if answerCall{
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
            LinphoneManager.linphoneCallErrorIndicator = true
        break
        
        case LinphoneCallReleased:
            LinphoneManager.releaseCallFlag = true
            print("callStateChanged: LinphoneCallReleased", "====")
            
        break
        
        default:
            print("callStateChanged: Default", "====")
        break
    }
}

class LinphoneManager {
    static let incomingCallInstance = IncomingCallController()
    static var linphoneCallStatus: String = ""
    static var linphoneCallErrorIndicator = false
    static var callOpaquePointerData: Optional<OpaquePointer>
    static var lcOpaquePointerData: Optional<OpaquePointer>
    static var incomingCallFlag: Bool = false {
        didSet {
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
        let calleeAccount = phoneNumber
//
//        guard let _ = setIdentify() else {
//            print("no identity")
//            return;
//        }
        linphone_core_invite(theLinphone.lc, calleeAccount)
//        setTimer()
//        shutdown()
    }
    
    static func receiveCall() {
//        guard let proxyConfig = setIdentify() else {
//            print("no identity")
//            return;
//        }
//        register(proxyConfig)
        linphone_core_accept_call(theLinphone.lc, LinphoneManager.callOpaquePointerData)
//        setTimer()
//        shutdown()
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
        var dividedRemodeAddrStr = remoteAddrStr?.components(separatedBy: delimiter)
        
        let callerID = dividedRemodeAddrStr?[2].substring(to: (dividedRemodeAddrStr?[2].index((dividedRemodeAddrStr?[2].endIndex)!, offsetBy: -15))!).substring(from: (dividedRemodeAddrStr?[2].index((dividedRemodeAddrStr?[2])!.startIndex, offsetBy: 6))!)
        
        return callerID!
    }
    
    static func getContactName() -> String {
        print(LinphoneManager.callOpaquePointerData, "PPPP")
        if LinphoneManager.callOpaquePointerData != nil {
            let remoteAddr = linphone_address_as_string(linphone_call_get_remote_address(LinphoneManager.callOpaquePointerData))
            let remoteAddrStr:String? = String(cString: remoteAddr!)
            let delimiter = "\""
            var dividedRemodeAddrStr = remoteAddrStr?.components(separatedBy: delimiter)
            
            let contactName = dividedRemodeAddrStr?[1]
            
            return contactName!
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
    }
    
    static func endCall() {
        linphone_core_terminate_call(LinphoneManager.lcOpaquePointerData, LinphoneManager.callOpaquePointerData)
    }
    
    func LinphoneInit() {
        proxyConfig = setIdentify()
        LinphoneManager.register(proxyConfig!)
        setTimer()
//        shutdown()
    }
    
    func setIdentify() -> OpaquePointer? {
        // Reference: http://www.linphone.org/docs/liblinphone/group__registration__tutorials.html
        
//        let path = Bundle.main.path(forResource: "Secret", ofType: "plist")
//        let dict = NSDictionary(contentsOfFile: path!)
//        let account = dict?.object(forKey: "account") as! String
//        let password = dict?.object(forKey: "password") as! String
//        let domain = dict?.object(forKey: "domain") as! String
        
        let account = "1111232"
        let password = "A2apbx10100"
        let domain = "192.168.7.251:5060"
        
        let identity = "sip:" + account + "@" + domain;

        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return nil
        }
        
        let info=linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(theLinphone.lc, info); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String(cString: linphone_address_get_domain(from)); /*extract domain address from identity*/
        
        linphone_address_destroy(from); /*release resource*/
        
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr); /* we assume domain = proxy server address*/
        linphone_proxy_config_enable_register(proxy_cfg, 0); /* activate registration for this proxy config*/
        linphone_core_add_proxy_config(theLinphone.lc, proxy_cfg); /*add proxy config to linphone core*/
        linphone_core_set_default_proxy_config(theLinphone.lc, proxy_cfg); /*set to default proxy*/
        
        return proxy_cfg!
    }
    
    static func register(_ proxy_cfg: OpaquePointer){
        linphone_proxy_config_enable_register(proxy_cfg, 1); /* activate registration for this proxy config*/
    }
    
    func shutdown(){
        NSLog("Shutdown..")
        
        let proxy_cfg = linphone_core_get_default_proxy_config(theLinphone.lc); /* get default proxy config*/
        linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
        linphone_proxy_config_enable_register(proxy_cfg, 0); /*de-activate registration for this proxy config*/
        linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
        while(linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationCleared){
            linphone_core_iterate(theLinphone.lc); /*to make sure we receive call backs before shutting down*/
            ms_usleep(50000);
        }
        
        linphone_core_destroy(theLinphone.lc);
    }
    
    @objc func iterate(){
        if let lc = theLinphone.lc {
            linphone_core_iterate(lc); /* first iterate initiates registration */
        }
    }
    
    fileprivate func setTimer(){
        LinphoneManager.iterateTimer = Timer.scheduledTimer(
            timeInterval: 0.02, target: self, selector: #selector(iterate), userInfo: nil, repeats: true)
    }
}

