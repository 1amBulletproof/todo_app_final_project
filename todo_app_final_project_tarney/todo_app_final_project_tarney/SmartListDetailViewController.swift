//
//  SmartListDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class SmartListDetailViewController: UIViewController, UITextViewDelegate{
    //MARK: - Class Properties
    static let DEFAULT_COMBO_BOX_VALUE = "None"
    //UI Elements
    @IBOutlet weak var smartListNameText: UITextView!
    @IBOutlet weak var listComboBox1: UIPickerView!
    @IBOutlet weak var listComboBox2: UIPickerView!
    @IBOutlet weak var listComboBox3: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedLabel: UILabel!
    //UI Element values
    var list1ChosenValue: List?
    var list2ChosenValue: List?
    var list3ChosenValue: List?
    //Database values
    let dbManager = DatabaseManager()
    var listsFromDB:[List] = []
    static var nextSmartListIdNumber:Int64! = 0
    var smartListToUpdate: SmartList?
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self
        self.smartListNameText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        
        //TODO: should this be on the background thread?
        //TODO: does this need to go in the SEGUE code TO this view (so that it's prepopulated?!)
        self.setListsFromDB()
        self.listComboBox1.reloadAllComponents()
        self.listComboBox2.reloadAllComponents()
        self.listComboBox3.reloadAllComponents()
        SmartListDetailViewController.nextSmartListIdNumber = dbManager.getMaxSmartListId() + 1
        
        //IF we are UPDATING a TODO, SET the EXISTING VALUES
        if let existingSmartList = self.smartListToUpdate {
//            print("SmarListDetailViewController::viewWillAppear(): Existing SmartList, populating details")
            self.smartListNameText.text = existingSmartList.name
            //This gnarly code sets the ListComboBox Values based on the update todo existing lists
            var listComboBoxCounter = 1
            for list in existingSmartList.lists! {
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
                            print("_ERROR_SmartListDetailViewController::ViewWillAppear(): more than 3 lists attached to a TODO, should be impossible")
                        }
                        listComboBoxCounter = listComboBoxCounter + 1
                    }
                    listIndex = listIndex + 1
                }
            }
        }
    }
    
    func setListsFromDB() {
        self.listsFromDB = dbManager.getAllLists()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func textViewDidChange(_ textView: UITextView) {
        self.savedLabel.isHidden = true
    }
    
    @IBAction func saveSmartListDetails(_ sender: Any) {
//        print("SmartListDetailViewController::saveSmartListDetails(): Smart List name is \(self.smartListNameText.text)")
        
        var viewListSet: Set<List> = []
        if let chosenList1 = self.list1ChosenValue {
            viewListSet.insert(chosenList1)
//            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList1.name) to SmartList")
        }
        if let chosenList2 = self.list2ChosenValue {
            viewListSet.insert(chosenList2)
//            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList2.name) to SmartList")
        }
        if let chosenList3 = self.list3ChosenValue {
            viewListSet.insert(chosenList3)
//            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList3.name) to SmartList")
        }
//        print("adding \(viewListSet.count) lists to this smart list")

        let viewLists = Array(viewListSet)
        if let smartListToUpdate = self.smartListToUpdate {
            smartListToUpdate.name = self.smartListNameText.text
            smartListToUpdate.lists = viewListSet as NSSet
            dbManager.update(smartList: smartListToUpdate)
        } else {
            dbManager.insertSmartList(
                name: self.smartListNameText.text!,
                id: SmartListDetailViewController.nextSmartListIdNumber,
                lists: viewLists)
            
            SmartListDetailViewController.nextSmartListIdNumber = SmartListDetailViewController.nextSmartListIdNumber + 1
        }

        self.savedLabel.isHidden = false
    }

}

//MARK: - Picker DELEGATE
extension SmartListDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //row - 1 to account for the default combo box value == row 0
        if (row == 0) {
            return SmartListDetailViewController.DEFAULT_COMBO_BOX_VALUE
        } else {
            return self.listsFromDB[row-1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.listsFromDB.count > 0 { //only do this if we have data
            //Subtract 1 from the row to account for "DEFAULT_COMBO_BOX_VALUE" as the basic option for row 0
//                print("SmartListDetailViewController::didSelectRow(): selected \(self.listsFromDB[row-1])")
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

//MARK: - Picker DATA SRC
extension SmartListDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //add an extra spot for "DEFAULT_COMBO_BOX_VALUE"
        return (self.listsFromDB.count + 1)
    }
    
}


