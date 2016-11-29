import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    
    var flowController: FlowController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        navigationController = UINavigationController()
        flowController = FlowController(rootController: navigationController)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navigationController
        window?.bounds = UIScreen.mainScreen().bounds
        window?.makeKeyAndVisible()
        flowController.presentFirstController()
        return true
    }
}

