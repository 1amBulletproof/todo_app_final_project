//
//  ListDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class ListDetailViewController: UIViewController, UITextViewDelegate {
    //MARK: - Class Properties
    //Db Stuff
    let dbManager = DatabaseManager()
    static var nextListIdNumber:Int64! = 0
    var listToUpdate: List?
    //UI Elements
    @IBOutlet weak var listNameText: UITextView!
    @IBOutlet weak var savedLabel: UILabel!

    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listNameText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        ListDetailViewController.nextListIdNumber = self.dbManager.getMaxListId() + 1

        if let listToUpdate = self.listToUpdate {
            self.listNameText.text = listToUpdate.name
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.savedLabel.isHidden = true
    }
    
    @IBAction func saveListDetails(_ sender: Any) {
//        print("ListDetailViewController::saveListDetails(): List name is \(self.listNameText.text)")
        
        if let listToUpdate = self.listToUpdate {
            listToUpdate.name = self.listNameText.text
            dbManager.update(list: listToUpdate)
        } else {
            dbManager.insertList(
                name: self.listNameText.text!,
                id: ListDetailViewController.nextListIdNumber,
                todos: [])
            
            ListDetailViewController.nextListIdNumber = ListDetailViewController.nextListIdNumber + 1
        }

        self.savedLabel.isHidden = false
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
