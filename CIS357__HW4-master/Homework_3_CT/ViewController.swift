//
//  ViewController.swift
//  Homework_3_CT
//
//  Created by CIS Student on 9/22/18.
//  Copyright © 2018 CIS Student. All rights reserved.
//

import UIKit


class ViewController: UIViewController, SettingsViewControllerDelegate {

    
    
    @IBOutlet weak var mode_Button: UIButton!
    @IBOutlet weak var clear_Button: UIButton!
    @IBOutlet weak var calc_Button: UIButton!
    @IBOutlet weak var fromInput: UITextField!
    
    @IBOutlet weak var toInput: UITextField!
    
    @IBOutlet weak var from_Label: UILabel!
    
    @IBOutlet weak var to_Label: UILabel!
    
    
    
    var to_Value_L: LengthUnit = LengthUnit.Yards
    var from_Value_L: LengthUnit = LengthUnit.Meters
    
    var to_Value_V: VolumeUnit = VolumeUnit.Gallons
    var from_Value_V: VolumeUnit = VolumeUnit.Liters
 
    var currentmode: CalculatorMode = CalculatorMode.Length
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboard))
        let detectMetersBox = UITapGestureRecognizer(target: self, action: #selector(self.clearBoxMeters))
        let detectYardsBox = UITapGestureRecognizer(target: self, action: #selector(self.clearBoxYards))
        
        self.view.addGestureRecognizer(detectTouch)
        self.toInput.addGestureRecognizer(detectYardsBox)
        self.fromInput.addGestureRecognizer(detectMetersBox)
        
    }

    @objc func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func clearBoxMeters(){
        self.toInput.text = ""
    }
    @objc func clearBoxYards(){
        self.fromInput.text = ""
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit) {
        from_Label.text = fromUnits.rawValue
        to_Label.text = toUnits.rawValue
        
        to_Value_L = toUnits
        from_Value_L = fromUnits
        
    }
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit) {
        from_Label.text = fromUnits.rawValue
        to_Label.text = toUnits.rawValue
        
        to_Value_V = toUnits
        from_Value_V = fromUnits
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination.childViewControllers[0] as? Mode_Select_ViewController{
            dest.delegate = self
            dest.modeSelected = currentmode
            dest.fromText = from_Label.text!
            dest.toText = to_Label.text!
        }
    }
    
    @IBAction func calculateFunc(_ sender: UIButton) {
        var input: Double = 0.0
        
        if(fromInput.text == ""){
            input = Double(self.toInput.text!)!
        }else if(toInput.text == "") {
            input = Double(self.fromInput.text!)!
        }
        
        var conv_num: Double = 0.0
        var solution: Double = 0.0
        
        if(currentmode == .Length){
        
            if(fromInput.text == ""){
                for value in lengthConversionTable {
                    if value.key == LengthConversionKey(toUnits: to_Value_L, fromUnits: from_Value_L) {
                        conv_num = value.value
                    }
                }
            }
            else{
                for value in lengthConversionTable {
                        if value.key == LengthConversionKey(toUnits: from_Value_L, fromUnits: to_Value_L) {
                            conv_num = value.value
                        }
                    }
                }
        }
        else{
            if(toInput.text == ""){
                for value in volumeConversionTable {
                    if value.key == VolumeConversionKey(toUnits: to_Value_V, fromUnits: from_Value_V) {
                        conv_num = value.value
                    }
                }
            }
            else{
                for value in volumeConversionTable {
                    if value.key == VolumeConversionKey(toUnits: from_Value_V, fromUnits: to_Value_V) {
                        conv_num = value.value
                    }
                }
            }
            
        }
        
        solution = input * conv_num
        if(toInput.text == ""){
            toInput.text = String(solution)
        }else if(fromInput.text == ""){
            fromInput.text = String(solution)
        }
        
    }
    
  
    @IBAction func clearPressed(_ sender: UIButton) {
        self.fromInput.text = ""
        self.toInput.text = ""
    }
    
    @IBAction func modePressed(_ sender: UIButton) {
        self.fromInput.text = ""
        self.toInput.text = ""
        
        if(currentmode == .Length){
            currentmode = .Volume
            from_Label.text = from_Value_V.rawValue
            to_Label.text = to_Value_V.rawValue
            toInput.placeholder = "Enter in Volume"
            fromInput.placeholder = "Enter in Volume"
        }
        else{
            currentmode = .Length
            from_Label.text = from_Value_L.rawValue
            to_Label.text = to_Value_L.rawValue
            toInput.placeholder = "Enter in Length"
            fromInput.placeholder = "Enter in Length"
        }
    }
    
    
}

