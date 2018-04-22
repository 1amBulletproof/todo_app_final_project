//
//  ViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/11/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class TestDBViewController: UIViewController {
    
    @IBOutlet weak var insertResult: UILabel!
    @IBOutlet weak var queryResult: UILabel!
    @IBOutlet weak var updateResult: UILabel!
    
    var nextAvailableId:Int64 = 0
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get access to the core data context
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.insertResult.text = "Insert Result"
        self.queryResult.text = "Query Result"
        self.updateResult.text = "Update Result"
    }
    
    @IBAction func insertAction(_ sender: Any) {
        print("TestDB::insertAction(): insert action")
        
        let context = appDelegate.persistentContainer.viewContext
        
        //insert for testing
        let todo = NSEntityDescription.insertNewObject(forEntityName:
            "Todo", into: context) as! Todo
        todo.todoID = self.nextAvailableId
        self.nextAvailableId += 1
        todo.name = "todo 1"
        todo.dueDate = Date.distantPast
        todo.details = "This is the first todo"
        
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into:context) as! List
        list.name = "List 1"
        list.listID = self.nextAvailableId
        self.nextAvailableId += 1
        
        //relationships
        list.addToTodos(todo)
        todo.addToLists(list)
        
        appDelegate.saveContext()
        
        //update view w/ results?
        self.insertResult.text = "inserted todo id:\(todo.todoID)\ninserted list id:\(list.listID)"
    }
    
    @IBAction func queryAction(_ sender: Any) {
        print("TestDB::queryAction(): query action")
        
        //query for testing
        let context = appDelegate.persistentContainer.viewContext
        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        
//        let predicate = NSPredicate(format: "todoID == 1")
//        fetchRequest.predicate = predicate
        
        do {
            let todos = try context.fetch(todoFetchRequest)
            let lists = try context.fetch(listFetchRequest)

            //update view w/ results
            self.queryResult.text = "Query found \(todos.count) todos & \(lists.count) lists\n"
        } catch {
            print("TestDB::queryAction(): error is \(error)")
        }
    }
    
    @IBAction func updateAction(_ sender: Any) {
        print("TestDB::updateAction(): update action")
        
        //update/delete for testing
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        let smartListFetchRequest: NSFetchRequest<SmartList> = SmartList.fetchRequest()
        
        do {
            let todos = try context.fetch(fetchRequest)
            for todo in todos {
                context.delete(todo)
                
                //update view w/ results
                self.updateResult.text = "\ndeleted a todo"
                self.nextAvailableId = 0
            }
            let lists = try context.fetch(listFetchRequest)
            for list in lists {
                context.delete(list)
                
                //update view w/ results
                self.updateResult.text! += "\ndeleted a list"
            }
            
            let smartLists = try context.fetch(smartListFetchRequest)
            for smartList in smartLists {
                context.delete(smartList)
                
                //update view w/ results
                self.updateResult.text! += "\ndeleted a smart list"
            }

        } catch {
            print("TestDB::updateAction(): error is \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


