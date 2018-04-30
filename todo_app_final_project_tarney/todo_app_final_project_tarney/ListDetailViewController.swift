//
//  TagDetailViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/18/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class ListDetailViewController: UIViewController {

    @IBOutlet weak var listNameText: UITextView!
    @IBOutlet weak var savedLabel: UILabel!
    
    let dbManager = DatabaseManager()
    
    static var nextListIdNumber:Int64! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
        ListDetailViewController.nextListIdNumber = self.dbManager.getMaxListId() + 1
    }
    
    @IBAction func saveListDetails(_ sender: Any) {
        print("ListDetailViewController::saveListDetails(): List name is \(self.listNameText.text)")
        
        dbManager.insertList(
            name: self.listNameText.text!,
            id: ListDetailViewController.nextListIdNumber,
            todos: [])
    
        ListDetailViewController.nextListIdNumber = ListDetailViewController.nextListIdNumber + 1
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
