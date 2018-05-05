//
//  TodoDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController, UITextViewDelegate {
    //MARK: - Class Properties
    static let DEFAULT_COMBO_BOX_VALUE = "None"
    static let NONE = "None"
    
    //DB Stuff
    let dbManager = DatabaseManager()
    var listsFromDB:[List] = []
    static var nextTodoIdNumber:Int64! = 0
    
    var todoToUpdate: Todo?

    //UI Elements in this view
    @IBOutlet weak var todoNameText: UITextView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var listComboBox1: UIPickerView!
    @IBOutlet weak var listComboBox2: UIPickerView!
    @IBOutlet weak var listComboBox3: UIPickerView!
    @IBOutlet weak var savedLabel: UILabel!
    
    //UI Element values
    var list1ChosenValue: List?
    var list2ChosenValue: List?
    var list3ChosenValue: List?
    var todoDetailNotes: String = ""

    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set self as delegate/datasource for UI Elements
        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self
        self.todoNameText.delegate = self
        
        //Add date picker callbacks
        self.startDatePicker.addTarget(self, action: #selector(TodoDetailViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.dueDatePicker.addTarget(self, action: #selector(TodoDetailViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        self.listsFromDB = dbManager.getAllLists()
        
        self.listComboBox1.reloadAllComponents()
        self.listComboBox2.reloadAllComponents()
        self.listComboBox3.reloadAllComponents()
        
        TodoDetailViewController.nextTodoIdNumber = self.dbManager.getMaxTodoId() + 1

        //IF we are UPDATING a TODO, SET the EXISTING VALUES
        if let existingTodo = self.todoToUpdate {
//            print("TodoDetailViewController::viewWillAppear(): Existing TODO, populating details")
            
            //Set Todo Values
            self.todoNameText.text = existingTodo.name
            self.startDatePicker.date = existingTodo.startDate!
            self.dueDatePicker.date = existingTodo.dueDate!
            self.todoDetailNotes = existingTodo.details!
            
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
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        self.savedLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.savedLabel.isHidden = true
    }
    @IBAction func todoDetailNotesButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowTodoDetailNotes", sender: nil)
    }
    
    @IBAction func saveTodo(_ sender: Any) {
//        print("TodoDetailViewController::saveListDetails(): Todo name is \(self.todoNameText.text)")

        var viewListSet: Set<List> = []
        if let chosenList1 = self.list1ChosenValue {
            viewListSet.insert(chosenList1)
//            print("TodoDetailViewController::saveTodo(): adding list \(chosenList1.name) to SmartList")
        }
        if let chosenList2 = self.list2ChosenValue {
            viewListSet.insert(chosenList2)
//            print("TodoDetailViewController::saveTodo(): adding list \(chosenList2.name) to SmartList")
        }
        if let chosenList3 = self.list3ChosenValue {
            viewListSet.insert(chosenList3)
//            print("TodoDetailViewController::saveTodo(): adding list \(chosenList3.name) to SmartList")
        }
//        print("There are \(viewListSet.count) lists select for this todo")
        
        let viewLists = Array(viewListSet)
        
        if let updateTodo = self.todoToUpdate {
            //Updating an existing TODO
            updateTodo.name = self.todoNameText.text!
            updateTodo.details = self.todoDetailNotes
            updateTodo.dueDate = self.dueDatePicker.date
            updateTodo.startDate = self.startDatePicker.date
            dbManager.update(todo: updateTodo)
        } else {
            //Inserting a new TODO
            dbManager.insertTodo(
                name: self.todoNameText.text!,
                id: TodoDetailViewController.nextTodoIdNumber,
                lists: viewLists,
                details: self.todoDetailNotes,
                startDate: self.startDatePicker.date,
                dueDate: self.dueDatePicker.date)
            
            TodoDetailViewController.nextTodoIdNumber = TodoDetailViewController.nextTodoIdNumber + 1
        }

        self.savedLabel.isHidden = false
        
    }
    
    override func didReceiveMemoryWarning()  { super.didReceiveMemoryWarning() }
    
    // MARK: - PREPARE FOR SEG
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTodoDetailNotes" {
            let todoDetailNotesView = segue.destination as! TodoNotesViewController
            todoDetailNotesView.todoDetailsView = self
        }
    }
}

//MARK: - UIPickerView DELEGATE
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
            if pickerView == self.listComboBox1 {
                if row > 0 {
                    self.list1ChosenValue = self.listsFromDB[row-1]
                } else {
                    self.list1ChosenValue = nil
                }
            } else if pickerView == self.listComboBox2 {
                if row > 0 {
                    self.list2ChosenValue = self.listsFromDB[row-1]
                } else {
                    self.list2ChosenValue = nil
                }
            } else {
                if row > 0 {
                    self.list3ChosenValue = self.listsFromDB[row-1]
                } else {
                    self.list3ChosenValue = nil
                }
            }
        }
        self.savedLabel.isHidden = true
    }
}

//MARK: - UIPickerView DATA SRC
extension TodoDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //add an extra spot for "DEFAULT_COMBO_BOX_VALUE"
        return self.listsFromDB.count + 1
    }
    
}




