//
//  AJAutocompletePlaceTextfield.swift
//  MTMsTask
//
//  Created by host on 13/01/2022.
//

import Foundation
import GooglePlaces

class AJAutocompletePlaceTextfield: UITextField , UITextFieldDelegate {
    
    //MARK: - PROPERTIES
    /// Instance of autoCompleteTableView
    fileprivate var autoCompleteTableView:UITableView?
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
   
    /// this is the x margin for table view from textfield
    open var autoCompleteTableMargin = CGFloat()

    //MARK: - INIT FUNCTIONS
        
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        setupAutocompleteTable(superview!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
        setupAutocompleteTable(superview!)
        
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        commonInit()
        setupAutocompleteTable(newSuperview!)
    }
    
    fileprivate func commonInit(){
        
        hidesWhenEmpty = true
        highLightTypeTextedEnabled = false
//        highLightTypeTextedAttributes = [NSForegroundColorAttributeName:UIColor.black]
//        highLightTypeTextedAttributes![NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 12)
        self.clearButtonMode = .always
        self.addTarget(self, action: #selector(AJAutocompletePlaceTextfield.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(AJAutocompletePlaceTextfield.textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    fileprivate func setupAutocompleteTable(_ view:UIView){
        
        autoCompleteTableMargin = 10.0
     //   let tableView = UITableView(frame: CGRect(x: self.frame.origin.x + autoCompleteTableMargin, y: self.frame.origin.y + self.frame.height, width: (self.frame.width ), height: 50.0))
        
//
       let tableView = UITableView(frame: CGRect(x: self.frame.origin.x + autoCompleteTableMargin/2, y: self.frame.origin.y + 80, width: (self.frame.width - autoCompleteTableMargin), height: 200.0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.lightGray
        tableView.rowHeight = autoCompleteCellHeight
        tableView.isHidden = hidesWhenEmpty ?? true
//        tableView.layer.borderColor = UIColor.lightGray.cgColor
//        tableView.layer.borderWidth = 0.5
//        tableView.layer.zPosition = CGFloat.greatestFiniteMagnitude
        view.addSubview(tableView)
        autoCompleteTableView = tableView
        autoCompleteTableHeight = 200.0
    }
    
    fileprivate func redrawTable(){
        
        if let autoCompleteTableView = autoCompleteTableView, let autoCompleteTableHeight = autoCompleteTableHeight {
            var newFrame = autoCompleteTableView.frame
            newFrame.size.height = autoCompleteTableHeight
            autoCompleteTableView.frame = newFrame
        }
    }
    
    //MARK: - Private Methods
    
//    fileprivate func showHighlightedTypedText(aStr : NSString) -> NSAttributedString {
//
//        let attrs = [NSAttributedString.Key.foregroundColor:UIColor.gray, NSAttributedString.Key.font:UIFont(name: "system", size: 18)] as! [String:Any]
//        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
//
//        let range = aStr.range(of: text!, options: .caseInsensitive)
//
//        let at = NSAttributedString(string: aStr as String, attributes: myAttribute)
//        let attString = NSMutableAttributedString(string: aStr as String, attributes: attrs)
//        attString.addAttributes(highLightTypeTextedAttributes ?? [String:Any], range: range)
//        autoCompleteTextColor = UIColor.gray
//        return attString
//    }

    //MARK: - AJAutoCompleteTextfieldDelegate
    @objc func textFieldDidChange(){
    //    let placesClient = GMSPlacesClient()
        
        
    
        let placesClient = GMSPlacesClient.shared()
        
      
        
        placesClient.findAutocompletePredictions(fromQuery: text!, filter: nil, sessionToken: nil, callback: { (results, error) in
            
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
                        self.autoCompleteTableHeight = 200
                    }
                    self.autoCompleteTableView?.reloadData()
                }else{
                    self.hidesWhenEmpty = true
                }
                self.autoCompleteTableView?.isHidden =  self.hidesWhenEmpty!
            }
        })
    }
    
    @objc func textFieldDidEndEditing() {
        autoCompleteTableView?.isHidden = true
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate
extension AJAutocompletePlaceTextfield: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompletePlacesData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        if highLightTypeTextedEnabled!{
            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            cell?.textLabel?.attributedText = NSAttributedString(string: autoCompletePlacesData[indexPath.row] as String, attributes: myAttribute)

           // cell?.textLabel?.attributedText = showHighlightedTypedText(aStr: autoCompletePlacesData[indexPath.row] as NSString)
        }else{
            cell?.textLabel?.font = autoCompleteTextFont
            cell?.textLabel?.textColor = autoCompleteTextColor
            cell?.textLabel?.text = autoCompletePlacesData[indexPath.row]
            
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let selectedText = cell?.textLabel?.text {
            self.text = selectedText
            self.resignFirstResponder()
            selectedPlace!(selectedText, indexPath)
        }
        
        DispatchQueue.main.async {
            //tableView.isHidden = self.hidesWhenSelected

            tableView.isHidden = true
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = autoCompleteSeparatorInset
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = autoCompleteSeparatorInset
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
}
