//
//  ViewDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class ViewDetailViewController: UIViewController {
    
    let tags = ["marzipan", "active", "gym", "important"]

    @IBOutlet weak var viewName: UITextView!
    @IBOutlet weak var tagComboBox1: UIPickerView!
    @IBOutlet weak var tagComboBox2: UIPickerView!
    @IBOutlet weak var tagComboBox3: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tagComboBox1.delegate = self
        self.tagComboBox1.dataSource = self
        self.tagComboBox2.delegate = self
        self.tagComboBox2.dataSource = self
        self.tagComboBox3.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveViewDetails(_ sender: Any) {
        print("save view details")
        print("View name is \(self.viewName.text)")
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

extension ViewDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected \(self.tags[row])")
    }
}

extension ViewDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.tags.count
    }
    
}


