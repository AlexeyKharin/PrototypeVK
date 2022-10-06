import Foundation
import UIKit

protocol PageViewControllerDelegate {
    func toggleMenu()
}

class ContainerViewController: UIViewController, PageViewControllerDelegate {
    
    var pageController: PageViewController
    
    var menuViewController: MenuViewController
    
    var isMove = false
    
    init(pageController: PageViewController, menuViewController: MenuViewController) {
        self.pageController = pageController
        self.menuViewController = menuViewController
        super.init(nibName: nil, bundle: nil)
        configurePageViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configurePageViewController() {
        pageController.pageDelegate = self
        menuViewController.delegate = self
        view.addSubview(pageController.view)
        addChild(pageController)
    }
    
    func configureMenuViewController() {
        view.insertSubview(menuViewController.view, at: 0)
        addChild(menuViewController)
    }
    
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // показываем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.pageController.view.frame.origin.x = self.pageController.view.frame.width - 70
            }) { (finished) in
            }
        } else {
            // убираем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.pageController.view.frame.origin.x = 0
            }) { (finished) in
            }
        }
    }
    
    // MARK:- PageViewControllerDelegate
    func toggleMenu() {
        configureMenuViewController()
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
}
