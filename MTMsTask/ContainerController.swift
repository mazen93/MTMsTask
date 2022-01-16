//
//  ContainerController.swift
//  uber-clone
//
//  Created by Ted Hyeong on 27/10/2020.
//

import UIKit
//import Firebase

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    private let homeController = ViewController()
    private var menuController: MenuController!
    private var isExpaned = false
    private let blackView = UIView()
    private lazy var xOrigin = self.view.frame.width - 80
    
//    private var user: User? {
//        didSet {
//            guard let user = user else { return }
//            homeController.user = user
//            configureMenuController(withUser: user)
//        }
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpaned
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - Selectors
    
    @objc func dismissMenu() {
        isExpaned = false
        animateMenu(shouldExpand: isExpaned)
    }
    
    // MARK: - API
    
   
    
  
   
    
    // MARK: -  Helpers
    
    func configure() {
       // view.backgroundColor = .backgroundColor
        configureHomeController()
    }
    
    func configureHomeController() {
//        addChild(homeController)
//        homeController.didMove(toParent: self)
//        view.addSubview(homeController.view)
//        homeController.delegate = self
        
        let vc = ControllProvider.viewController(className: ViewController.self, stoaryboard:.mainStoaryboard, presentStyle: .fullScreen)
       // vc.delegate = self

        present(vc, animated: true, completion: nil)
    }
    
    func configureMenuController() {
      //  menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        menuController.view.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height - 40)
        view.insertSubview(menuController.view, at: 0)
        menuController.delegate = self
        configureBlackView()
    }
    
    func configureBlackView() {
        blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {

        
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.xOrigin
                self.blackView.alpha = 1
            }, completion: nil)

        } else {
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)
        }
        
        animateStatusBar()
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}



//MARK: - HomeControllerDelegate



extension ContainerController: MenuControllerDelegate {
    func didSelect(options: MenuOptions) {
        isExpaned.toggle()
        animateMenu(shouldExpand: isExpaned) { _ in
            switch options {
            case .yourTrips:
                break
            case .settings:
                print("n")
            case .logout:
               print("n")
            }
        }
    }
}
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
    static let outlineStrokeColor = UIColor.rgb(red: 234, green: 46, blue: 111)
    static let trackStrokeColor = UIColor.rgb(red: 56, green: 25, blue: 49)
    static let pulsatingFillColor = UIColor.rgb(red: 86, green: 30, blue: 63)
}
