
import Foundation
import UIKit

/*
 Add new storyboards in here for easy referencing.
 Dont forget to add identity storyboard id for the
 UIViewController classs.
 */

enum AppStoryboard: String {
    
    case main = "Main"
    case user = "User"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyboardID
        let scene = instance.instantiateViewController(withIdentifier: storyBoardID) as? T
        return scene
    }
    
}

extension UIViewController {
    
    static var storyboardID: String {
        return "\(self)"
    }
    
    /// Convenience type method to initialize a view controller from a specified stroyboard
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)!
    }
}

