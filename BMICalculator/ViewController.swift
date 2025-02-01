//
//  ViewController.swift
//  BMICalculator
//
//  Created by Vaisakh Suresh on 2025-01-31.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var heightUnitLabel: UILabel!
    @IBOutlet weak var heightMainLabel: UILabel!
    
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var weightMainLabel: UILabel!
    
    @IBOutlet weak var unitSystemSegment: UISegmentedControl!
    @IBOutlet weak var bmiHeaderLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiCategoryLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    var unitMode = "Metric"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default values
        unitSystemSegment.selectedSegmentIndex = 0
        updateUnitLabels()
    }
    
    @IBAction func unitSystemChange(_ sender: UISegmentedControl) {
        updateUnitLabels()
    }
    
    func updateUnitLabels() {
        heightField.text = ""
        weightField.text = ""
        resultLabel.text = ""
        bmiHeaderLabel.isHidden = true
        bmiLabel.isHidden = true
        bmiCategoryLabel.isHidden = true
        if unitSystemSegment.selectedSegmentIndex == 0 {
            unitMode = "Metric"
            heightMainLabel.text = "Height (in centimeters):"
            heightUnitLabel.text = "CM"
            weightMainLabel.text = "Weight (in kilograms):"
            weightUnitLabel.text = "KG"
        } else {
            unitMode = "Imperial"
            heightMainLabel.text = "Height (in feet):"
            heightUnitLabel.text = "FT"
            weightMainLabel.text = "Weight (in pounds):"
            weightUnitLabel.text = "LB"
        }
    }
    
    @IBAction func calculateClick(_ sender: UIButton) {
        if !validateHeightWeight(heightField.text, weightField.text) {
//            resultLabel.textColor = .systemRed
//            resultLabel.text = "Invalid input: Please enter valid height and weight"
            
            let message = "\nPlease enter valid height and weight"
            let alert = UIAlertController(title: "Invalid input!", message: message, preferredStyle: .alert)
            let tapAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(tapAction)
            self.present(alert, animated: true)
            return
            }

            // Extract validated height and weight
            let heightValue = Double(heightField.text!)!
            let weightValue = Double(weightField.text!)!

        
        var bmi: Double = 0.0
        
        if unitMode == "Metric" {
            bmi = calculateMetricBMI(heightValue, weightValue)
        } else {
            bmi = calculateImperialBMI(heightValue, weightValue)
        }
        
        bmiLabel.isHidden = false
        bmiCategoryLabel.isHidden = false
        bmiHeaderLabel.isHidden = false
        
        // This is for closing keyboard 
        heightField.resignFirstResponder()
        weightField.resignFirstResponder()
        
        bmiLabel.text = bmiResultArray(bmi)[0]
        bmiCategoryLabel.text = bmiResultArray(bmi)[1]
        resultLabel.text = bmiResultArray(bmi)[2]
        
    }
    
    func validateHeightWeight(_ height: String?, _ weight: String?) -> Bool {
        // Check if either field is empty or nil
        guard let height = height, !height.isEmpty,
              let weight = weight, !weight.isEmpty else {
            return false
        }
        
        // Convert to Double and check if values are valid numbers
        guard let heightValue = Double(height),
              let weightValue = Double(weight) else {
            return false
        }
        
        // Ensure values are positive
        if heightValue <= 0 || weightValue <= 0 {
            return false
        }
        
        return true
    }

    
    func calculateProgress(_ bmi: Double) -> Float {
        let minBMI: Float = 10.0  // Lowest expected BMI
        let maxBMI: Float = 40.0  // Highest expected BMI

        // Ensure BMI stays within min/max range
        let normalizedBMI = min(max(Float(bmi), minBMI), maxBMI)

        // Map BMI range [10, 40] to progress range [0.1, 1.0]
        let progress = 0.1 + (normalizedBMI - minBMI) / (maxBMI - minBMI) * (1.0 - 0.1)

        return progress
        
    }
    
    func calculateMetricBMI(_ height: Double, _ weight: Double) -> Double {
        return (weight / pow(height / 100, 2))  // Convert cm to meters
    }
    
    func calculateImperialBMI(_ heightInFeet: Double, _ weightInPounds: Double) -> Double {
        let feet = floor(heightInFeet)  // Get the whole number part (feet)
        let inches = (heightInFeet - feet) * 10 // Get the fractional part (multiply by 10 to get inches)

        let totalHeightInInches = (feet * 12) + inches
        return (weightInPounds / pow(totalHeightInInches, 2)) * 703
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        heightField.text = ""
        weightField.text = ""
        resultLabel.text = ""
        bmiHeaderLabel.isHidden = true
        bmiLabel.isHidden = true
        bmiCategoryLabel.isHidden = true
    }
    
    func bmiResultArray(_ bmi: Double) -> [String] {
        let bmiString = String(format: "%.1f", bmi)
        if bmi < 18.5 {
            let result = "Underweight"
            let resultDescription = """
            You may need to gain weight.
            Ask your doctor if this is a healthy weight
            for you.
            """
            bmiLabel.textColor = .systemBlue
            return [bmiString, result, resultDescription]
        } else if bmi < 25 {
            let result = "Normal Weight"
            let resultDescription = """
            You have a healthy weight!
            Try not to gain or lose weight. 
            Eat healthy and be physically active.
            """
            bmiLabel.textColor = .systemGreen
            return [bmiString, result, resultDescription]
        } else if bmi < 30 {
            let result = "Overweight"
            let resultDescription = """
            You may need to lose weight.
            Talk to your doctor or dietitian about 
            your health risks and if you need
            to lose weight.
            """
            bmiLabel.textColor = .systemOrange
            return [bmiString, result, resultDescription]
        } else {
            let result = "Obese"
            let resultDescription = """
            You need to lose weight.
            Talk to your doctor or dietitian about 
            safe and effective ways to lose
            weight and keep it off.
            """
            bmiLabel.textColor = .systemRed
            return [bmiString, result, resultDescription]
        }
    }
    
    
    



}
