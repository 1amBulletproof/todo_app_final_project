//
//  TodoDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var todoNameText: UITextView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var listComboBox1: UIPickerView!
    @IBOutlet weak var listComboBox2: UIPickerView!
    @IBOutlet weak var listComboBox3: UIPickerView!
    @IBOutlet weak var savedLabel: UILabel!
    
    let list = ["marzipan", "active", "gym", "important"]
    
    var appDelegate:AppDelegate!
    static var nextTodoIdNumber:Int64!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        TodoDetailViewController.nextTodoIdNumber = 0;
        
        //Date picker how-to: https://stackoverflow.com/questions/40484182/ios-swift-3-uidatepicker

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
    }
    
    @IBAction func saveTodo(_ sender: Any) {
        print("ListDetailViewController::saveListDetails(): List name is \(self.listNameText.text)")
        
        let context = self.appDelegate.persistentContainer.viewContext
        
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        list.name = self.listNameText.text!
        list.listID = self.nextListIdNumber
        
        appDelegate.saveContext()
        
        self.nextListIdNumber = self.nextListIdNumber + 1
        self.savedLabel.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TodoDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.list[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("TodoDetailViewController::didSelectRow(): selected \(self.list[row])")
    }
}

extension TodoDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }
    
}
