//
//  ProviderDelegate.swift
//  vKclub
//
//  Created by HuySophanna on 22/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import AVFoundation
import CallKit

extension ProviderDelegate: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        print("Stop Audio ==STOP-AUDIO==")
        
        for call in callKitManager.calls {
            call.end(uuid: UUID())
        }
        
        callKitManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // 1.
        guard let call = callKitManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        // 2.
        configureAudioSession()
        // 3.
        call.answer()
        // 4.
        if #available(iOS 11, *) {
            print ("vKclub")
        } else {
           
            action.fulfill()
        }
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // 1.
        guard let call = callKitManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        // 2.
        print("Stop audio ==STOP-AUDIO==")
        configureAudioSession()
        // 3.
        call.end(uuid: action.callUUID)
        // 4.
        if #available(iOS 11, *) {
           print("Our vKclube")
        } else {
            action.fulfill()
        }
        
        // 5.
        callKitManager.remove(call: call)
    }
    
    // 5.
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Starting audio ==STARTING-AUDIO==")
    }
    
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Received \(#function)")
    }
    
    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try? session.setMode(AVAudioSessionModeVoiceChat)
            try? session.setPreferredSampleRate(44100.0)
            try? session.setPreferredIOBufferDuration(0.005)
            try? session.setActive(true)
        } 
       
    }
}

class ProviderDelegate: NSObject {
    // 1.
    fileprivate let callKitManager: CallKitCallInit
    fileprivate let provider: CXProvider
    
    init(callKitManager: CallKitCallInit) {
        self.callKitManager = callKitManager
        // 2.
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        
        super.init()
        // 3.
        provider.setDelegate(self, queue: nil)
    }
    
    // 4.
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "vKclub")
        
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        return providerConfiguration
    }
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        // 1.
        configureAudioSession()
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                // 3.
                self.configureAudioSession()
                let call = CallKitCallInit(uuid: uuid, handle: handle)
                self.callKitManager.add(call: call)
                
                lastCallUUID = uuid
                print("UUID === ", uuid)
            }
            
            // 4.
            completion?(error as NSError?)
        }
    }
    
    
}


