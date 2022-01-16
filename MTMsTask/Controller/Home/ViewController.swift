//
//  ViewController.swift
//  MTMsTask
//
//  Created by host on 13/01/2022.
//

import UIKit
import GoogleMaps
import SideMenu

class ViewController: UIViewController,CLLocationManagerDelegate{
    
    
    
    
    var locationManager = CLLocationManager()
    
   
    
    @IBOutlet weak var yourLocationTF: UITextField!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var destinationTF: UITextField!
    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
    }
    
    private func setupView(){
     
        map.settings.compassButton = true

        // GOOGLE MAPS SDK: USER'S LOCATION
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true

        requestButton.layer.cornerRadius = 8
        self.map.bringSubviewToFront(self.requestView)
      

          //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        yourLocationTF.addTarget(self, action: #selector(textFieldAction), for: .touchDown)
        destinationTF.addTarget(self, action: #selector(textFieldAction), for: .touchDown)
       
    }
    @objc func textFieldAction(textField: UITextField) {
       
      //  performSegue(withIdentifier: "go", sender: self)
        let vc = ControllProvider.viewController(className: UserInputPopup.self, stoaryboard: .mainStoaryboard, presentStyle: .popover)
        present(vc, animated: true, completion: nil)
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.map.animate(to: camera)

        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }
 

    
    @IBAction func requestRDAction(_ sender: UIButton) {
    
       
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        
        slideMenuIn()
     
        
    }
    private func slideMenuIn(){
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        var set = SideMenuSettings()
        set.statusBarEndAlpha = 0
        set.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        set.presentationStyle.presentingEndAlpha = 0.1
        set.blurEffectStyle = .dark

        set.menuWidth = min(view.frame.width, view.frame.height) * 0.60
        menu.settings = set
        menu.presentationStyle = .menuSlideIn
        menu.leftSide=true
        present(menu, animated: true, completion: nil)
    }

    
    
}




    


