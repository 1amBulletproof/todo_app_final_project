//
//  ViewDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class SmartListDetailViewController: UIViewController {

    @IBOutlet weak var smartListNameText: UITextView!
    @IBOutlet weak var listComboBox1: UIPickerView!
    @IBOutlet weak var listComboBox2: UIPickerView!
    @IBOutlet weak var listComboBox3: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedLabel: UILabel!
    
    var list1ChosenValue: List?
    var list2ChosenValue: List?
    var list3ChosenValue: List?

    var appDelegate:AppDelegate!
    static var nextSmartListIdNumber:Int64!
    
    var listsFromDB:[List] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listComboBox1.delegate = self
        self.listComboBox1.dataSource = self
        self.listComboBox2.delegate = self
        self.listComboBox2.dataSource = self
        self.listComboBox3.delegate = self
        self.listComboBox3.dataSource = self
        
        //TODO: set the default value when view loads?
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate

        SmartListDetailViewController.nextSmartListIdNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        
        //TODO: add "NONE" to each list?!
        //TODO: should this be on the background thread?
        //TODO: does this need to go in the SEGUE code TO this view (so that it's prepopulated?!)
        self.setListsFromDB()
        self.listComboBox1.reloadAllComponents()
        self.listComboBox2.reloadAllComponents()
        self.listComboBox3.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSmartListDetails(_ sender: Any) {
        print("SmartListDetailViewController::saveSmartListDetails(): save Smart List details")
        print("SmartListDetailViewController::saveSmartListDetails(): Smart List name is \(self.smartListNameText.text)")
        
        let context = self.appDelegate.persistentContainer.viewContext
        
        let smartList = NSEntityDescription.insertNewObject(forEntityName: "SmartList", into: context) as! SmartList
        smartList.name = self.smartListNameText.text!
        smartList.smartListID = SmartListDetailViewController.nextSmartListIdNumber
 
        if let chosenList1 = self.list1ChosenValue {
            smartList.addToLists(chosenList1)
            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList1.name) to SmartList")
        }
        if let chosenList2 = self.list2ChosenValue {
            smartList.addToLists(chosenList2)
            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList2.name) to SmartList")
        }
        if let chosenList3 = self.list1ChosenValue {
            smartList.addToLists(chosenList3)
            print("SmartListDetailViewController::saveSmartListDetails(): adding list \(chosenList3.name) to SmartList")
        }
        
        appDelegate.saveContext()
        
        SmartListDetailViewController.nextSmartListIdNumber = SmartListDetailViewController.nextSmartListIdNumber + 1
        self.savedLabel.isHidden = false
    }
    
    func setListsFromDB() {
        let context = appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        
        do {
            let lists = try context.fetch(listFetchRequest)
            self.listsFromDB = lists
            
            print("SmartListDetailViewController::setListsFromDB(): SmartList UI Query for Lists found \(lists.count) lists\n")
        } catch {
            print("error is \(error)")
        }

    }
    
    // MARK: - Navigation/segues
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("SmartListDetailViewController::prepareForSegue(): segue is \(segue.identifier!)")
        //        let indexPath = tableView.indexPathForSelectedRow!
        //        let section = indexPath.section
        //        let row = indexPath.row
        //
        //        let vc = segue.destination as! SuperHeroDetailViewController
        //        vc.imageName = images[section][row]
        //        vc.heroName = superheroes[section][row]
        //        vc.companyName = companies[section]
        //        vc.powers = descriptions[section][row]
    }

}

extension SmartListDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listsFromDB[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.listsFromDB.count > 0 { //only do this if we have data
            print("SmartListDetailViewController::didSelectRow(): selected \(self.listsFromDB[row])")
            
            if pickerView == self.listComboBox1 {
                self.list1ChosenValue = self.listsFromDB[row]
            } else if pickerView == self.listComboBox2 {
                self.list2ChosenValue = self.listsFromDB[row]
            } else {
                self.list3ChosenValue = self.listsFromDB[row]
            }
            
        }
    }
}

extension SmartListDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listsFromDB.count
    }
    
}


