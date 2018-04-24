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
    
    var appDelegate:AppDelegate!
    static var nextListIdNumber:Int64!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        ListDetailViewController.nextListIdNumber = 0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedLabel.isHidden = true
    }
    
    @IBAction func saveListDetails(_ sender: Any) {
        print("ListDetailViewController::saveListDetails(): List name is \(self.listNameText.text)")

        let context = self.appDelegate.persistentContainer.viewContext
        
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        list.name = self.listNameText.text!
        list.listID = ListDetailViewController.nextListIdNumber
        
        appDelegate.saveContext()
    
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
