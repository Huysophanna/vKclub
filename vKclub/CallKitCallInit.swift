//
//  CallKitCallInit.swift
//  vKclub
//
//  Created by HuySophanna on 24/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//
import Foundation
import CallKit

enum CallState {
    case connecting
    case active
    case held
    case ended
}

enum ConnectedState {
    case pending
    case complete
}

var lastCallUUID: UUID = UUID()

class CallKitCallInit {
    private let callController = CXCallController()
    var incomingCallInstance = IncomingCallController()
    
    static var state: CallState = .ended {
        didSet {
            CallKitCallInit.stateChanged?()
        }
    }
    static var held: CallState = .held {
        didSet {
            CallKitCallInit.stateChanged?()
        }
    }
    
    var connectedState: ConnectedState = .pending {
        didSet {
            connectedStateChanged?()
        }
    }
    
    static var stateChanged: (() -> Void)?
    var connectedStateChanged: (() -> Void)?
    
    func start(completion: ((_ success: Bool) -> Void)?) {
        completion?(true)
        
        CallKitCallInit.state = .connecting
        self.connectedState = .pending
        CallKitCallInit.state = .active
        self.connectedState = .complete
    }
    func answer() {
        print("CALL ACCEPTED ======")
        checkCallKit = "checkCallkit"
        CallKitCallInit.state = .active
        
        //accept the call
        incomingCallInstance.acceptCallFlag = true
        incomingCallInstance.PresentIncomingVC()
    }
    
    
    func end(uuid: UUID) {
        print("CALL DECLINED/ENDED ======")
        CallKitCallInit.state = .ended
        
        // 1.
        let endCallAction = CXEndCallAction(call: uuid)
        print("ENDUUID === ", uuid)
        // 2.
        let transaction = CXTransaction(action: endCallAction)
        
        requestTransaction(transaction)
        
        if LinphoneManager.CheckLinphoneCallState() != LINPHONE_CALLSTREAM_RUNNING {
            //decline call
            LinphoneManager.declineCall(_declinedReason: LinphoneReasonBusy)
            incomingCallInstance.incomingCallFlags = false
            incomingCallInstance.releaseCallFlag = true
            //invalidate wait for stream running interval
            IncomingCallController.InvalidateWaitForStreamRunningInterval()
            
            
            
        } else if LinphoneManager.CheckLinphoneCallState() == LINPHONE_CALLSTREAM_RUNNING {
            //end in progress call
            incomingCallInstance.endCallFlag = true
        }
    }
    
    // 3.
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    let uuid: UUID
    let outgoing: Bool
    let handle: String
    
    init(uuid: UUID, outgoing: Bool = false, handle: String) {
        self.uuid = uuid
        self.outgoing = outgoing
        self.handle = handle
    }
    
    var callsChangedHandler: (() -> Void)?
    
    private(set) var calls = [CallKitCallInit]()
    
    func callWithUUID(uuid: UUID) -> CallKitCallInit? {
        guard let index = calls.index(where: { $0.uuid == uuid }) else {
            return nil
        }
        return calls[index]
    }
    
    func add(call: CallKitCallInit) {
        calls.append(call)
        CallKitCallInit.stateChanged = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.callsChangedHandler?()
        }
        callsChangedHandler?()
    }
    
    func remove(call: CallKitCallInit) {
        guard let index = calls.index(where: { $0 === call }) else { return }
        calls.remove(at: index)
        callsChangedHandler?()
    }
    
    func removeAllCalls() {
        calls.removeAll()
        callsChangedHandler?()
    }
    
}
