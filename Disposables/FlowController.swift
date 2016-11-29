import Foundation
import UIKit

class FlowController {
    
    private var rootController: UINavigationController
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    
    func presentFirstController() {
        let controller = ViewController()
        controller.signalAction.values.observeNext {
            self.presentSignalController()
        }
        controller.producerAction.values.observeNext { 
            self.presentProducerController()
        }
        rootController.pushViewController(controller, animated: true)
    }
    
    func presentSignalController() {
        let viewModel = SignalViewModel()
        let controller = SignalViewController(viewModel: viewModel)
        rootController.pushViewController(controller, animated: true)
    }
    
    func presentProducerController() {
        let viewModel = ProducerViewModel()
        let controller = ProducerViewController(viewModel: viewModel)
        rootController.pushViewController(controller, animated: true)
    }
    
}