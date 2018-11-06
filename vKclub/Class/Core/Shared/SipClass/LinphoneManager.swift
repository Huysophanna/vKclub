import Foundation
import AVFoundation

var answerCall: Bool = false
var outGoingCallPlayer = AVAudioPlayer()
var proxyConfig: OpaquePointer? = nil



struct theLinphone {
    static var lc: OpaquePointer?
    static var lct: LinphoneCoreVTable?
    static var manager: LinphoneManager?
    static var tp : LCSipTransports = LCSipTransports(udp_port: 5060, tcp_port: 0, dtls_port: 0, tls_port: 0)
}


let registrationStateChanged: LinphoneCoreRegistrationStateChangedCb  = {
    (lc: Optional<OpaquePointer>, proxyConfig: Optional<OpaquePointer>, state: _LinphoneRegistrationState, message: Optional<UnsafePointer<Int8>>) in
    
   
    
    switch state {
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        NSLog("LinphoneRegistrationNone")
        
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
        
    case LinphoneRegistrationOk:
        NSLog("LinphoneRegistrationOk")
        connectionCheck = true
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        connectionCheck = false
        
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
        connectionCheck = false
        
    default:
        NSLog("Unkown registration state")
    }
    } as LinphoneCoreRegistrationStateChangedCb

let callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: Optional<OpaquePointer>, call: Optional<OpaquePointer>, callSate: LinphoneCallState,  message: Optional<UnsafePointer<Int8>>) in
    
    LinphoneManager.callOpaquePointerData = call
    LinphoneManager.lcOpaquePointerData = lc
    
    if LinphoneManager.mainCallOpaquePointerData == nil {
        LinphoneManager.mainCallOpaquePointerData = call
        LinphoneManager.mainLcOpaquePointerData = lc
    }
    
    switch callSate{
    case LinphoneCallIncomingReceived: /**<This is a new incoming call */
          NSLog("callStateChanged: LinphoneCallError")
          InComeCallController.incomingCallFlags = true
        
    case LinphoneCallStreamsRunning: /**<The media streams are established and running*/
         InComeCallController.callSteaming = true
         if !InComeCallController.dialPhone {
            InComeCallController.callToFlag = true
         }
    case LinphoneCallError: /**<The call encountered an error*/
        NSLog("callStateChanged: LinphoneCallError")
        InComeCallController.endCall = true
        
    case LinphoneCallEnd:
        if !InComeCallController.endCall {
           InComeCallController.endCall = true
        }
      
        
    case LinphoneCallIdle:
        NSLog("Call idle")
  
    case LinphoneCallReleased:
        
        InComeCallController.endCall = false
        InComeCallController.callSteaming = false
        InComeCallController.dialPhone = false
        
    case LinphoneCallOutgoingInit :
        NSLog("LinphoneCallOutgoingInit")
        
    case LinphoneCallOutgoingProgress:
        NSLog("LinphoneCallOutgoingProgress")
        
    case LinphoneCallOutgoingRinging:
        NSLog("LinphoneCallOutgoingRinging")
   
    case LinphoneCallIncomingReceived :
        NSLog("LinphoneCallIncomingReceived")
    case LinphoneCallOutgoingRinging :
        NSLog("LinphoneCallOutgoingRinging")
        
    case LinphoneCallOutgoingEarlyMedia:
        NSLog("LinphoneCallOutgoingEarlyMedia")
        
    case LinphoneCallConnected :
        NSLog("LinphoneCallConnected")

    default:
        print(callSate,"$$$$$")
        NSLog("Default call state")
    }
    
    
    
}




class LinphoneManager {
    
    static var iterateTimer: Timer?
    static var linphoneCallStatus: String = ""
    static var callOpaquePointerData: Optional<OpaquePointer>
    static var lcOpaquePointerData: Optional<OpaquePointer>
    static var mainCallOpaquePointerData: Optional<OpaquePointer>
    static var mainLcOpaquePointerData: Optional<OpaquePointer>
    static var LinphoneRegistrationStatus : Bool?
    
    init() {
        
        theLinphone.lct = LinphoneCoreVTable()
        
        // Enable debug log to stdout
        linphone_core_set_log_file(nil)
        linphone_core_set_log_level(ORTP_DEBUG)
        
        // Load config
        let configFilename = documentFile("linphonerc")
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
    
    func linphoneInit(account : String) {
        guard let proxyConfig = setIdentify(account: account) else {
            return
        }
        register(proxyConfig)
        setTimer()
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
    
  

    static func makeCall(phoneNumber: String) {
        
          linphone_core_invite(theLinphone.lc, phoneNumber)
    }
    
    static func endCall() {
        
        linphone_core_terminate_call(LinphoneManager.lcOpaquePointerData, LinphoneManager.callOpaquePointerData)
        linphone_core_terminate_all_calls(LinphoneManager.lcOpaquePointerData)
        
    }
    
    static func receiveCall() {
        linphone_core_accept_call(theLinphone.lc, LinphoneManager.callOpaquePointerData)
    }
    
    static func getCurrentCallDuration() -> (Int, Int, Int) {
        let duration = Int(linphone_core_get_current_call_duration(LinphoneManager.lcOpaquePointerData))
        let hour = duration / 3600
        let minute = (duration % 3600) / 60
        let second = (duration % 3600) % 60
        
        return (hour, minute, second)
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
        
//       print(dividedRemodeAddrStr)
        
        return "343243"

        
    }
    
   
    
    
    
    
    
    
    func setIdentify(account: String) -> OpaquePointer? {
        print(account)
        print("data")

        let password = "V1252JKo*"
        let domain =  "192.168.7.136"
        
        let identity = "sip:" + account + "@" + domain;
        
        
        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return nil
        }
//        linphone_address_set_transport(from, LinphoneTransportTls)
//        linphone_address_set_port(from,5061)
//        linphone_address_set_secure(from, 1)
        //        linphone_auth_info_set_tls_cert_path(from,"TLS certificate path")
        //linphone_core_set_root_ca(theLinphone.lc, "/Users/machintos-hd/KIT/Oudom/cafile.pem")
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
        linphone_core_set_sip_transports(theLinphone.lc,&theLinphone.tp)
        
        linphone_media_encryption_to_string(LinphoneMediaEncryptionSRTP)
        return proxy_cfg!
    }
    
    func register(_ proxy_cfg: OpaquePointer){
        linphone_proxy_config_enable_register(proxy_cfg, 1); /* activate registration for this proxy config*/
    }
    
    static func shutdown(){
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
        if let lc = theLinphone.lc{
            linphone_core_iterate(lc); /* first iterate initiates registration */
        }
    }
    
    fileprivate func setTimer(){
        LinphoneManager.iterateTimer = Timer.scheduledTimer(
            timeInterval: 0.02, target: self, selector: #selector(iterate), userInfo: nil, repeats: true)
    }
    
}


