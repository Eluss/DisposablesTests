import Foundation
import UIKit
import PureLayout
import ReactiveCocoa
import enum Result.NoError

class ProducerViewController: UIViewController {
    
    private var viewModel: ProducerViewModel
    private var label: UILabel!
    private var composite = CompositeDisposable()
    
    init(viewModel: ProducerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Producer"
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
        view.backgroundColor = UIColor.greenColor()
        label = UILabel()
        label.text = "Hi"
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
    
    private func setupObservers() {
        viewModel.producer.startWithSignal { (signal, disposable) in
            composite += disposable
            composite += signal.observeNext({ [weak self] (text) in
                print("observe next block")
                guard let weakSelf = self else { return }
                weakSelf.label.text = text
            })
        }
    }
    
    deinit {
        composite.dispose()
        print("[DEINIT] ---> ViewController ")
    }
}

class ProducerViewModel {
    
    var producer: SignalProducer<String, NoError>!
    
    init() {
        producer = SignalProducer<String, NoError> {[unowned self](observer, composite) in
            self.work(observer, disposable: composite)
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