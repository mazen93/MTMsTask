//
//  ControllProvider.swift
//  shokran
//
//  Created by Mohamed Macbook on 9/22/20.
//  Copyright © 2020 Mohamed. All rights reserved.
//

import Foundation
import UIKit
enum StoaryboardType:String{
    case mainStoaryboard="Main"
}




class ControllProvider{
    
    
    
    class func viewController<vc: UIViewController>(className:vc.Type,stoaryboard:StoaryboardType,presentStyle:UIModalPresentationStyle) -> vc{
        let mainSB=UIStoryboard(name: stoaryboard.rawValue, bundle: nil)
        let identifier=String(describing: className.self)
        if #available(iOS 13.0, *) {
            let vc=mainSB.instantiateViewController(identifier: identifier) as! vc
            vc.modalPresentationStyle = presentStyle
                return vc
        } else {
            // Fallback on earlier versions
            let vc=mainSB.instantiateViewController(withIdentifier: identifier) as! vc
            vc.modalPresentationStyle = presentStyle
                   return vc
        }
       
    }
}
