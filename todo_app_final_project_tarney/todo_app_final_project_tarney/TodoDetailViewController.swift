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
    
    static let DEFAULT_COMBO_BOX_VALUE = "None"
    
    var list1ChosenValue: List?
    var list2ChosenValue: List?
    var list3ChosenValue: List?
    
    let dbManager = DatabaseManager()
    
    var listsFromDB:[List] = []
    
    var todoToUpdate: Todo?
    
    static var nextTodoIdNumber:Int64! = 0
    
    static let NONE = "None"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        self.listsFromDB = dbManager.getAllLists()
        
        self.listComboBox1.reloadAllComponents()
        self.listComboBox2.reloadAllComponents()
        self.listComboBox3.reloadAllComponents()

        //IF we are UPDATING a TODO, SET the EXISTING VALUES
        if let existingTodo = self.todoToUpdate {
            print("TodoDetailViewController::viewWillAppear(): Existing TODO, populating details")
            
            //Set Todo Values
            self.todoNameText.text = existingTodo.name
            self.startDatePicker.date = existingTodo.startDate!
            self.dueDatePicker.date = existingTodo.dueDate!
            
            //This gnarly code sets the ListComboBox Values based on the update todo existing lists
            var listComboBoxCounter = 1
            for list in existingTodo.lists! {
//                print("list in existing TODO")
                let existingList = list as! List
                var listIndex = 1
                for queriedList in self.listsFromDB {
//                    print("list in queriedList")
                    if existingList == queriedList {
//                        print("existing list == queriedList @ index \(listIndex)")
                        switch listComboBoxCounter {
                        case 1:
                            self.listComboBox1.selectRow(listIndex, inComponent: 0, animated: false)
                        case 2:
                            self.listComboBox2.selectRow(listIndex, inComponent: 0, animated: false)
                        case 3:
                            self.listComboBox3.selectRow(listIndex, inComponent: 0, animated: false)
                        default:
                            print("_ERROR_TodoDetailViewController::ViewWillAppear(): more than 3 lists attached to a TODO, should be impossible")
                        }
                        listComboBoxCounter = listComboBoxCounter + 1
                    }
                    listIndex = listIndex + 1
                }
            }

            
        }
        
        TodoDetailViewController.nextTodoIdNumber = self.dbManager.getMaxTodoId() + 1
    
    }
    
    @IBAction func saveTodo(_ sender: Any) {
        print("TodoDetailViewController::saveListDetails(): Todo name is \(self.todoNameText.text)")

        
        var viewListSet: Set<List> = []
        if let chosenList1 = self.list1ChosenValue {
            viewListSet.insert(chosenList1)
            print("TodoDetailViewController::saveTodo(): adding list \(chosenList1.name) to SmartList")
        }
        if let chosenList2 = self.list2ChosenValue {
            viewListSet.insert(chosenList2)
            print("TodoDetailViewController::saveTodo(): adding list \(chosenList2.name) to SmartList")
        }
        if let chosenList3 = self.list3ChosenValue {
            viewListSet.insert(chosenList3)
            print("TodoDetailViewController::saveTodo(): adding list \(chosenList3.name) to SmartList")
        }
        print("There are \(viewListSet.count) lists select for this todo")
        
        let viewLists = Array(viewListSet)
        
        dbManager.insertTodo(
            name: self.todoNameText.text!,
            id: TodoDetailViewController.nextTodoIdNumber,
            lists: viewLists,
            details: "",
            startDate: self.startDatePicker.date,
            dueDate: self.dueDatePicker.date)

        TodoDetailViewController.nextTodoIdNumber = TodoDetailViewController.nextTodoIdNumber + 1
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
        //row - 1 to account for the default combo box value == row 0
        if (row == 0) {
            return TodoDetailViewController.DEFAULT_COMBO_BOX_VALUE
        } else {
            return self.listsFromDB[row-1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.listsFromDB.count > 0 { // only do tihs if we have data
            //Subtract 1 from the row to account for "DEFAULT_COMBO_BOX_VALUE" as the basic option for row 0
            if row > 0 {
                print("TodoDetailViewController::didSelectRow(): selected \(self.listsFromDB[row-1].name)")
                if pickerView == self.listComboBox1 {
                    self.list1ChosenValue = self.listsFromDB[row-1]
                } else if pickerView == self.listComboBox2 {
                    self.list2ChosenValue = self.listsFromDB[row-1]
                } else {
                    self.list3ChosenValue = self.listsFromDB[row-1]
                }
            }
        }
    }
}

extension TodoDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //add an extra spot for "DEFAULT_COMBO_BOX_VALUE"
        return self.listsFromDB.count + 1
    }
    
}




