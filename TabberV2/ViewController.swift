//
//  ViewController.swift
//  tips
//
//  Created by Jessie Chen on 8/6/15.
//  Copyright © 2015 Jessie Chen. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ViewController: UIViewController {
    
   
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipsParenthesis: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var total2Label: UILabel!
    @IBOutlet weak var total3Label: UILabel!
    @IBOutlet weak var total4Label: UILabel!
    @IBOutlet weak var p1: UIImageView!
    @IBOutlet weak var p2: UIImageView!
    @IBOutlet weak var p3: UIImageView!
    @IBOutlet weak var p4: UIImageView!
    @IBOutlet weak var p5: UIImageView!
    @IBOutlet weak var p6: UIImageView!
    @IBOutlet weak var p7: UIImageView!
    @IBOutlet weak var p8: UIImageView!
    @IBOutlet weak var p9: UIImageView!
    @IBOutlet weak var p10: UIImageView!
    @IBOutlet weak var lightArea: UIView!
    @IBOutlet weak var darkArea: UIView!
    @IBOutlet weak var maxReachedLabel: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    var colorIndex: Int!
    var timeLapse: TimeInterval = TimeInterval();
    var lastBillAmount: String = "$0.00";
    
    
    // override func viewWillAppear(animated: Bool) {
    //     navigationItem.title = "Tabber"
    // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        total2Label.text = "$0.00"
        total3Label.text = "$0.00"
        total4Label.text = "$0.00"
        percentageLabel.text = "18%"
        lightArea.alpha = 1
        darkArea.alpha = 0
        //tipControl.hidden = true
        tipLabel.isHidden = true
        tipsParenthesis.isHidden = true
        percentageLabel.isHidden = true
        maxReachedLabel.isHidden = true
        
        
        billField.text = "$"
        
        billField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        navigationController?.navigationBar.tintColor = UIColor.black;
        
        if let defaultPercentage = defaults.object(forKey: "defaultTipPercentage") {
            
            if let defaultTipChanged = defaults.object(forKey: "defaultChanged"){
                if (defaultTipChanged as! String == "Y"){
            percentageSlider.value = (defaultPercentage as AnyObject).floatValue;
                }}}

        percentageLabel.text = String(format: "%.2f", percentageSlider.value) + " %"
       
        if let colorTheme = defaults.object(forKey: "colorTheme"){
            colorIndex = colorTheme as! Int;
        }else {
            colorIndex = 0;
        }
        
        if colorIndex == 0{
            lightArea.backgroundColor  = UIColor( red: 252/255, green: 255/255, blue:145/255, alpha: 1.0 );
            darkArea.backgroundColor =
                UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0);
        navigationController?.navigationBar.barTintColor = UIColor( red: 252/255, green: 255/255, blue:145/255, alpha: 1.0 );
            percentageSlider.maximumTrackTintColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0);
            percentageSlider.thumbTintColor = UIColor(red: 255/255, green: 70/255, blue: 0/255, alpha: 1.0);
            
        }else{
            lightArea.backgroundColor  = UIColor( red: 208/255, green: 255/255, blue:255/255, alpha: 1.0);
            darkArea.backgroundColor =
                UIColor(red: 84/255, green: 114/255, blue: 151/255, alpha: 0.5);
            navigationController?.navigationBar.barTintColor = UIColor( red: 208/255, green: 255/255, blue:255/255, alpha: 1.0 );
            percentageSlider.maximumTrackTintColor = UIColor.white;
            percentageSlider.thumbTintColor = UIColor( red: 21/255, green: 79/255, blue:137/255, alpha: 1.0 );
        }
        
        if let lastClosed = defaults.object(forKey: "timeClosed") as? Date {

        timeLapse = Date().timeIntervalSince(lastClosed)
        }
        
        if let lastBillAmount = defaults.object(forKey: "lastBillAmount"){
        if timeLapse < 5 {
            billField.text = lastBillAmount as! String;
            print(self.billField.center.y)
            if (self.billField.center.y >= 185){
            self.billField.center.y = self.billField.center.y - 70
            }
            
            UIView.animate(withDuration: 0.4, animations:{
                self.darkArea.alpha = 1
                self.tipLabel.isHidden = false
                self.tipsParenthesis.isHidden = false
                self.percentageLabel.isHidden = false
                
            })
        }
            
            percentageLabel.text = String(format: "%.2f", percentageSlider.value) + " %"
            
            let tipPercentage = percentageSlider.value / 100
            
            var billAmount = NSString(string: billField.text!).doubleValue
            
            //Set max limit: = total + tip = $99999.99 at 30% tip
            if (billAmount > 76923.07){
                billAmount = 76923.07
                maxReachedLabel.isHidden = false
            }
            
            var tip = billAmount * Double(tipPercentage)
            var total = billAmount + tip

            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            //formatter.locale = Locale.current // This is the default
            
            
            if let formatIndex = defaults.object(forKey: "formatIndex") {
                print("formatIndex:\(formatIndex)")
                switch(formatIndex as! Int){
                
                case 0:  //USD
                    formatter.locale = Locale.current
                    print("USD:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                    break;

                case 1: //EUR
                    formatter.locale = Locale(identifier: "es_ES")
                    print("es_ES:" + formatter.string(from: NSNumber.init( value:  Double(total)))!) // "123,44 €"
                    break;
                    
                case 2: //GBP
                    formatter.locale = Locale(identifier: "kw_GB")
                    print("kw_GB" + formatter.string(from: NSNumber.init( value: total))!) // "123,44 €"
                    break;
                    
                case 3: //JPY
                    formatter.locale = Locale(identifier: "ja_JP")
                    print("ja_JP:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                    break;
                    
                case 4: //TWD
                    formatter.locale = Locale(identifier: "zh_Hant_TW")
                    print("zh_Hant_TW:" + formatter.string(from: NSNumber.init(value: total))!)
                    if (billAmount > 769.22){
                        billAmount = 769.22
                        maxReachedLabel.isHidden = false
                    }
                    print("billAmountTWD:\(billAmount)")
                    tip = billAmount * Double(tipPercentage)
                    total = billAmount + tip
                    print("totalTWD:\(total)")
                    break;
                    
                case 5:  //THB
                    formatter.locale = Locale(identifier: "th_TH")
                    print("th_TH:" + formatter.string(from: NSNumber.init(value: total))!)
                    if (billAmount > 769.22){
                        billAmount = 769.22
                        maxReachedLabel.isHidden = false
                    }
                    print("billAmountTHB:\(billAmount)")
                    tip = billAmount * Double(tipPercentage)
                    total = billAmount + tip
                    print("totalTHB:\(total)")
                    break;
                    
                default: //USD
                    formatter.locale = Locale.current // This is the default
                    print("default:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                    break;
                    
                }}

            tipLabel.text = formatter.string(from: NSNumber.init(value: tip))
            totalLabel.text = formatter.string(from: NSNumber.init(value: total))
            total2Label.text = formatter.string(from: NSNumber.init(value: total/2))
            total3Label.text = formatter.string(from: NSNumber.init(value: total/3))
            total4Label.text = formatter.string(from: NSNumber.init(value: total/4))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "timeClosed")
        defaults.set(billField.text, forKey: "lastBillAmount")
        defaults.synchronize()
        maxReachedLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func onEditingChanged(_ sender: AnyObject) {
        print(billField.text)
        
        maxReachedLabel.isHidden = true
        
        if(billField.text?.characters.count > 0)
        {
            
            let a: Character = "$"
            let b: Character = (billField.text?.characters.first)!
            
            if(a == b){
                billField.text!.remove(at: billField.text!.startIndex)
                if (self.darkArea.alpha == 0){
                    self.billField.center.y = self.billField.center.y - 70
                }
            }

            
            UIView.animate(withDuration: 0.4, animations:{
                self.darkArea.alpha = 1
                self.tipLabel.isHidden = false
                self.tipsParenthesis.isHidden = false
                self.percentageLabel.isHidden = false
                
            })
            
        }else {
            UIView.animate(withDuration: 0.4, animations:{
                if (self.darkArea.alpha == 1){
                    self.billField.center.y = self.billField.center.y + 70
                }
                self.darkArea.alpha = 0
                //self.tipControl.hidden = true
                self.tipLabel.isHidden = true
                self.tipsParenthesis.isHidden = true
                self.percentageLabel.isHidden = true
                self.billField.text = "$"
            })
            
        }
        

        percentageLabel.text = String(format: "%.2f", percentageSlider.value) + " %"

        let tipPercentage = percentageSlider.value / 100
        var billAmount = NSString(string: billField.text!).doubleValue

        print("billAmount1:\(billAmount)")
        
        //Set max limit: = total + tip = $99999.99 at 30% tip
        if (billAmount > 76923.07){
            billAmount = 76923.07
            maxReachedLabel.isHidden = false
        }
    
        print("billAmount2:\(billAmount)")
        
        var tip = billAmount * Double(tipPercentage)
        var total = billAmount + tip
        
        
        let defaults = UserDefaults.standard
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        
        if let formatIndex = defaults.object(forKey: "formatIndex") {
            print("formatIndex:\(formatIndex)")
            switch(formatIndex as! Int){
            case 0:  //USD
                formatter.locale = Locale.current
                print("USD:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                break;
                
            case 1: //EUR
                formatter.locale = Locale(identifier: "es_ES")
                print("es_ES:" + formatter.string(from: NSNumber.init( value:  Double(total)))!) // "123,44 €"
                break;
                
            case 2: //GBP
                formatter.locale = Locale(identifier: "kw_GB")
                print("kw_GB" + formatter.string(from: NSNumber.init( value: total))!) // "123,44 €"
                break;
                
            case 3: //JPY
                formatter.locale = Locale(identifier: "ja_JP")
                print("ja_JP:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                break;
                
            case 4: //TWD
                formatter.locale = Locale(identifier: "zh_Hant_TW")
                print("zh_Hant_TW:" + formatter.string(from: NSNumber.init(value: total))!)
                if (billAmount > 769.22){
                    billAmount = 769.22
                    maxReachedLabel.isHidden = false
                }
                print("billAmountTWD:\(billAmount)")
                tip = billAmount * Double(tipPercentage)
                total = billAmount + tip
                print("totalTWD:\(total)")
                break;
                
            case 5:  //THB
                formatter.locale = Locale(identifier: "th_TH")
                print("th_TH:" + formatter.string(from: NSNumber.init(value: total))!)
                if (billAmount > 769.22){
                    billAmount = 769.22
                    maxReachedLabel.isHidden = false
                }
                print("billAmountTHB:\(billAmount)")
                tip = billAmount * Double(tipPercentage)
                total = billAmount + tip
                print("totalTHB:\(total)")
                break;
                
            default: //USD
                formatter.locale = Locale.current // This is the default
                print("default:" + formatter.string(from: NSNumber.init(value: total))!) // "123,44 €"
                break;
                
            }}
        
        tipLabel.text = formatter.string(from: NSNumber.init(value: tip))
        totalLabel.text = formatter.string(from: NSNumber.init(value: total))
        total2Label.text = formatter.string(from: NSNumber.init(value: total/2))
        total3Label.text = formatter.string(from: NSNumber.init(value: total/3))
        total4Label.text = formatter.string(from: NSNumber.init(value: total/4))
        
        //tipLabel.text = String(format: "$%.2f", tip)
        //totalLabel.text = String(format: "$%.2f", total)
        //total2Label.text = String(format: "$%.2f", total/2)
        //total3Label.text = String(format: "$%.2f", total/3)
        //total4Label.text = String(format: "$%.2f", total/4)
        
        
           }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
}
