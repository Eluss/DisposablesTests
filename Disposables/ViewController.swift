import UIKit
import PureLayout
import ReactiveCocoa
import enum Result.NoError


class ViewController: UIViewController {

    var signalButton: UIButton!
    var producerButton: UIButton!
    var signalAction: Action<Void, Void, NoError>!
    var signalCocoaAction: CocoaAction!
    
    var producerAction: Action<Void, Void, NoError>!
    var producerCocoaAction: CocoaAction!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        signalAction = Action<Void, Void, NoError>({ () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { (observer, disposable) in
                observer.sendNext()
                observer.sendCompleted()
            }
        })
        
        producerAction = Action<Void, Void, NoError>({ () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { (observer, disposable) in
                observer.sendNext()
                observer.sendCompleted()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = UIColor.whiteColor()
        signalButton = UIButton()
        signalButton.setTitle("Signal", forState: .Normal)
        view.addSubview(signalButton)
        signalButton.autoCenterInSuperview()
        signalButton.autoSetDimensionsToSize(CGSizeMake(100, 100))
        signalButton.backgroundColor = UIColor.blueColor()
        signalCocoaAction = CocoaAction(signalAction) { _ in }
        signalButton.addTarget(signalCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        producerButton = UIButton()
        producerButton.setTitle("Producer", forState: .Normal)
        view.addSubview(producerButton)
        producerButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: signalButton, withOffset: -20)
        producerButton.autoAlignAxisToSuperviewAxis(.Vertical)
        producerButton.autoSetDimensionsToSize(CGSizeMake(100, 100))
        producerButton.backgroundColor = UIColor.greenColor()
        producerCocoaAction = CocoaAction(producerAction) { _ in }
        producerButton.addTarget(producerCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}
