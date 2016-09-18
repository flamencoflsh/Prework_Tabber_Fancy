//
//  SettingsViewController.swift
//  TabberV2
//
//  Created by Jessie Chen on 9/17/16.
//  Copyright © 2016 Jessie Chen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var defaultTipPercentageView: UIView!
    
    @IBOutlet weak var colorThemeView: UIView!
    
   // @IBOutlet weak var defaultTipLabel: UILabel!
    
    @IBOutlet weak var defaultTipTextfield: UITextField!
    
    @IBOutlet weak var defaultTipSlider: UISlider!
    
    @IBOutlet weak var colorThemeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var currencyFormatPickerView: UIPickerView!
    
    @IBOutlet weak var currencyView: UIView!
    
    //let pickerData = ["1,234,567.89", "1 234 567.89", "1 234 567,89", "1,234,567·89", "1.234.567,89", "1˙234˙567,89", "12,34,567.89", "1'234'567.89", "1'234'567,89", "1.234.567’89", "1.234.567,89", "123,4567.89"]
    
    let pickerData = ["USD", "EUR", "GBP", "JPY", "TWD", "THB"]
    
    var colorIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatPickerView.dataSource = self
        currencyFormatPickerView.delegate = self
        
        
        defaultTipPercentageView.layer.borderColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.2 ).cgColor;
        
        defaultTipPercentageView.layer.borderWidth = 0.5;
        
        colorThemeView.layer.borderColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.2 ).cgColor;
        
        colorThemeView.layer.borderWidth = 0.5;
        
        currencyView.layer.borderColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.2 ).cgColor;
        
        currencyView.layer.borderWidth = 0.5;

        let defaults = UserDefaults.standard
        defaults.set("N", forKey: "defaultChanged")
        defaults.synchronize()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let defaultPercentage = defaults.object(forKey: "defaultTipPercentage") {
            defaultTipSlider.value = (defaultPercentage as AnyObject).floatValue;
        }
        
      //  defaultTipLabel.text = String(format: "%.2f", defaultTipSlider.value) + " %"
        
        defaultTipTextfield.text = String(format: "%.2f", defaultTipSlider.value) + " %"
        
        if let colorTheme = defaults.object(forKey: "colorTheme"){
            colorIndex = colorTheme as! Int;
        }else {
            colorIndex = 0;
        }
        
        colorThemeSegmentedControl.selectedSegmentIndex = colorIndex;
        
        if let selectedRow = defaults.object(forKey: "formatIndex") {
            
        currencyFormatPickerView.selectRow(selectedRow as! Int, inComponent: 0, animated: true)
            
        }else{
            
            currencyFormatPickerView.selectRow(0, inComponent: 0, animated: true)
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        defaults.set(currencyFormatPickerView.selectedRow(inComponent: 0), forKey: "formatIndex")
        defaults.synchronize()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSliderMoved(_ sender: AnyObject) {
        
     //   defaultTipLabel.text = String(format: "%.2f", defaultTipSlider.value) + " %"
        
        defaultTipTextfield.text = String(format: "%.2f", defaultTipSlider.value) + " %"

        
        let defaults = UserDefaults.standard
        defaults.set(defaultTipTextfield.text, forKey: "defaultTipPercentage")
        defaults.set("Y", forKey: "defaultChanged")
        defaults.synchronize()
    }

    @IBAction func onTipTextfieldChanged(_ sender: AnyObject) {
        var floatValue:Float = 0
        let text = defaultTipTextfield.text! as String
        //let value = text.substring(to: (text.index(before: (text.endIndex))))
        print("value: \(text)END")
        
        floatValue = (text as NSString).floatValue
        defaultTipSlider.value = floatValue
    
        let defaults = UserDefaults.standard
        defaults.set(defaultTipTextfield.text, forKey: "defaultTipPercentage")
        defaults.set("Y", forKey: "defaultChanged")
        defaults.synchronize()
    }

    
    @IBAction func onColorThemeChanged(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        defaults.set(colorThemeSegmentedControl.selectedSegmentIndex, forKey: "colorTheme")
        defaults.synchronize()
        print("colorTheme" + "\(colorThemeSegmentedControl.selectedSegmentIndex)");
        
        if colorThemeSegmentedControl.selectedSegmentIndex == 0 {
            navigationController?.navigationBar.barTintColor = UIColor( red: 252/255, green: 255/255, blue:145/255, alpha: 1.0 );
        }else{
            navigationController?.navigationBar.barTintColor = UIColor( red: 208/255, green: 255/255, blue:255/255, alpha: 0.5);
            navigationController?.navigationBar.isTranslucent = true;
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
    }

//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let titleData = pickerData[row]
//        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
//        return myTitle
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            //let hue = CGFloat(row)/CGFloat(pickerData.count)
           // pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        return pickerLabel!
        
    }}
