//
//  ThirdVC.swift
//  MTMsTask
//
//  Created by host on 13/01/2022.
//

import UIKit
import GooglePlaces


class ThirdVC: UIViewController {
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    private var responseData:NSMutableData?
    private var dataTask:URLSessionDataTask?
    
    private let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextField()
        handleTextFieldInterfaces()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSAttributedString.Key.foregroundColor.rawValue] = UIColor.black
        attributes[NSAttributedString.Key.font.rawValue] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.textFieldDidChange(keyword: text)
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
         print(text)
        }
    }

 func textFieldDidChange(keyword:String){
    //    let placesClient = GMSPlacesClient()
        
        
    
        let placesClient = GMSPlacesClient.shared()
        
      
        
        placesClient.findAutocompletePredictions(fromQuery: keyword, filter: nil, sessionToken: nil, callback: { (results, error) in
            var locations = [String]()
            if results != nil {
                for result in results!{
                   locations.append(result.attributedFullText.string)
                }
            }
               
                    
                    DispatchQueue.main.async {
                        self.autocompleteTextfield.autoCompleteStrings = locations
                    }
                    return
               
            
        })
    }
    
//    private func fetchAutocompletePlaces(keyword:String) {
//        let urlString = "\(baseURLString)?key=\(googleMapsKey)&input=\(keyword)"
//        let s = NSCharacterSet.URLQueryAllowedCharacterSet as! NSMutableCharacterSet
//        s.addCharacters(in: "+&")
//        if let encodedString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(s) {
//            if let url = NSURL(string: encodedString) {
//                let request = NSURLRequest(URL: url)
//                dataTask = NSURLSession.sharedSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                    if let data = data{
//
//                        do{
//                            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//
//                            if let status = result["status"] as? String{
//                                if status == "OK"{
//                                    if let predictions = result["predictions"] as? NSArray{
//                                        var locations = [String]()
//                                        for dict in predictions as! [NSDictionary]{
//                                            locations.append(dict["description"] as! String)
//                                        }
//                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                            self.autocompleteTextfield.autoCompleteStrings = locations
//                                        })
//                                        return
//                                    }
//                                }
//                            }
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                self.autocompleteTextfield.autoCompleteStrings = nil
//                            })
//                        }
//                        catch let error as NSError{
//                            print("Error: \(error.localizedDescription)")
//                        }
//                    }
//                })
//                dataTask?.resume()
//            }
//        }
//    }
}
