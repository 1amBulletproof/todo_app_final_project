//
//  ViewDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class SmartListDetailViewController: UIViewController {

    @IBOutlet weak var listNameText: UITextView!
    @IBOutlet weak var listComboBox1: UIPickerView!
    @IBOutlet weak var listComboBox2: UIPickerView!
    @IBOutlet weak var listComboBox3: UIPickerView!
    
    let list = ["marzipan", "active", "gym", "important"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSmartListDetails(_ sender: Any) {
        print("save Smart List details")
        print("Smart List name is \(self.listNameText.text)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SmartListDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected \(self.list[row])")
    }
}

extension SmartListDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }
    
}


