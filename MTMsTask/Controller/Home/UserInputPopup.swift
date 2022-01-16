//
//  UserInputPopup.swift
//  MTMsTask
//
//  Created by host on 16/01/2022.
//

import UIKit
import SideMenu
import GooglePlaces
class UserInputPopup: UIViewController {

    
    
    var transparentView = UIView()
    
    
    private final let locationInputViewHeight: CGFloat = 200
  
    //MARK: - PROPERTIES
    /// Instance of autoCompleteTableView
    @IBOutlet weak var autoCompleteTableView:UITableView!
    /// Gives the array of autoCompletePlacesData
    open var autoCompletePlacesData = [String]()
    /// Gives the selected place and indexPath
    open var selectedPlace: ((String, IndexPath) -> ())?
    /// Font for the places data
    open var autoCompleteTextFont = UIFont.systemFont(ofSize: 12)
    /// Color of the places data
    open var autoCompleteTextColor = UIColor.black
    /// Used to set the height of cell for each suggestions
    open var autoCompleteCellHeight:CGFloat = 44.0
    /// The maximum visible suggestion
    open var maxAutoCompleteDataCount = 5
    /// Used to set your own preferred separator inset
    open var autoCompleteSeparatorInset = UIEdgeInsets.zero
    /// Hides autoCompleteTableView after selecting a place
    open var hidesWhenSelected = true
    /// Shows autoCompletePlacesData with formatting
    open var highLightTypeTextedEnabled:Bool?
    /// Define attributes for highlighted text
    open var highLightTypeTextedAttributes:[String:AnyObject]?
    /// Hides autoCompleteTableView when the textfield is empty
    open var hidesWhenEmpty:Bool?{
        didSet{
            DispatchQueue.main.async {
                self.autoCompleteTableView?.isHidden = self.hidesWhenEmpty!
            }
        }
    }
    /// The autoCompleteTableView height
    open var autoCompleteTableHeight:CGFloat?{
        didSet{
            redrawTable()
        }
    }
    
    @IBOutlet weak var yourLocationTF: UITextField!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var destinationTF: UITextField!
    
    
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    var textfieldTag:Int = 0
    @IBOutlet weak var searchView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         selectedPlace = {[weak self] place , indexPath in
                 guard let self=self else{return}
                
                 if self.textfieldTag == 1{
                     self.yourLocationTF.text = place
                 }else{
                     self.destinationTF.text = place
                 }
                
                 
             }
             setupView()
         }
         fileprivate func redrawTable(){
             
             if let autoCompleteTableView = autoCompleteTableView, let autoCompleteTableHeight = autoCompleteTableHeight {
                 var newFrame = autoCompleteTableView.frame
                 newFrame.size.height = autoCompleteTableHeight
                 autoCompleteTableView.frame = newFrame
             }
         }
         private func setupView(){
             yourLocationTF.becomeFirstResponder()
             setupAutocompleteTable()
             commonInit()
         }
      
         
         @IBAction func didTapBack(_ sender: UIBarButtonItem) {
             dismiss(animated: true, completion: nil)
        }
      
         fileprivate func commonInit(){

             hidesWhenEmpty = true
             highLightTypeTextedEnabled = false

         }
       
       
         
         
         
         
         
         // google places api
         internal func callPlacesAPI(text:String){
             let placesClient = GMSPlacesClient.shared()
             
             placesClient.findAutocompletePredictions(fromQuery: text, filter: nil, sessionToken: nil, callback: { (results, error) in
                 
                 DispatchQueue.main.async {
                     self.autoCompletePlacesData.removeAll()
                     if results != nil {
                         for result in results!{
                             self.autoCompletePlacesData.append(result.attributedFullText.string)
                         }
                     }
                     if self.autoCompletePlacesData.count != 0{
                        
                         self.hidesWhenEmpty = false
                         if self.autoCompletePlacesData.count < self.maxAutoCompleteDataCount{
                             self.autoCompleteTableHeight = self.autoCompleteTableView?.contentSize.height
                         }else{
                             self.autoCompleteTableHeight = self.searchView.frame.height
                         }
                         self.autoCompleteTableView?.reloadData()
                     }else{
                         self.hidesWhenEmpty = true
                     }
                     self.autoCompleteTableView?.isHidden =  self.hidesWhenEmpty!
                 }
             })
         }
         
         fileprivate func setupAutocompleteTable(){
             
          

             autoCompleteTableView.dataSource = self
             autoCompleteTableView.delegate = self
             autoCompleteTableView.separatorColor = UIColor.lightGray
             autoCompleteTableView.rowHeight = autoCompleteCellHeight
             autoCompleteTableView.isHidden = hidesWhenEmpty ?? true
             autoCompleteTableView.rowHeight = autoCompleteCellHeight
           //  autoCompleteTableHeight = self.searchView.frame.height
         }
         
         
     
         
     }




         


