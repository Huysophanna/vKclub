
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
        CallKitCallInit.state = .active
        InComeCallController.acceptCallFlag = true
    }
    
    
  
    
    
    func end(uuid: UUID) {
        print("CALL DECLINED/ENDED ======")
        CallKitCallInit.state = .ended
        
        // 1.
        let endCallAction = CXEndCallAction(call: uuid)
        print("ENDUUID === ", uuid)
        // 2.
        let transaction = CXTransaction(action: endCallAction)
        LinphoneManager.endCall()
        requestTransaction(transaction)
        
    }
    
    // 3.
    private func requestTransaction(_ transaction: CXTransaction) {
        print(transaction.actions,"#####")
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
