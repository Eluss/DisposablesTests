import Foundation
import UIKit
import PureLayout
import ReactiveCocoa
import enum Result.NoError

class SignalViewController: UIViewController {
    
    private var viewModel: SignalViewModel
    private var label: UILabel!
    private var composite = CompositeDisposable()
    
    init(viewModel: SignalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Signal"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupObservers()
    }
    
    private func setupViewController() {
        view.backgroundColor = UIColor.yellowColor()
        label = UILabel()
        label.text = "Hi"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    private func setupObservers() {
        composite.addDisposable(viewModel.signal.observeNext {[weak self] (text) in
            print("observe next block")
            guard let weakSelf = self else { return }
            weakSelf.label.text = text
        })
        composite.addDisposable(viewModel.signal.observeInterrupted {
            print("Interrupted block")
        })
    }
    
    deinit {
        composite.dispose()
        viewModel.disposable?.dispose()
        print("[DEINIT] ---> ViewController ")
    }
}

class SignalViewModel {
    
    var signal: Signal<String, NoError>!
    var disposable: Disposable?
    
    init() {
        signal = Signal<String, NoError> {(observer) -> Disposable? in
            disposable = ActionDisposable {
                print("Clearing ")
                observer.sendInterrupted()
            }
            work(observer, disposable: disposable!)
            return disposable
        }
    }
    
    
    
    func work(observer: Observer<String, NoError>, disposable: Disposable) {
        if !disposable.disposed {
            print("ViewModel is working ...")
            let delayTime1 = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime1, dispatch_get_main_queue()) {
                observer.sendNext("text")
                self.work(observer, disposable: disposable)
            }
        }
    }
    
    
    deinit {
        print("[DEINIT] ---> ViewModel")
    }
    
}