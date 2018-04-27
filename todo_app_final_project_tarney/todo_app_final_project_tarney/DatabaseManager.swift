//
//  DatabaseManager.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/22/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    var appDelegate:AppDelegate
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("DatabaseManager::init(): Initializing the DatabaseManager")
    }
    
}


extension DatabaseManager { //Write Methods
    
    //Reminder: cannot instantiate database classes like var list = List()
    //  thus instead of passing-in a List, pass-in the necessary variables
    
    func insertList(name:String, id:Int64, todos:[Todo]) {
        print("DatabseManager::insertList(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let listInsert = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        
        listInsert.listID = id
        listInsert.name = name
        let tmpTodos = NSSet(array: todos)
        listInsert.todos = tmpTodos
        
        appDelegate.saveContext()
    }
    
    func insertSmartList(name:String, id:Int64, lists:[List]) {
        print("DatabseManager::insertSmartList(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let smartListInsert = NSEntityDescription.insertNewObject(forEntityName: "SmartList", into: context) as! SmartList
        
        smartListInsert.name = name
        smartListInsert.smartListID = id
        let tmpLists = NSSet(array: lists)
        smartListInsert.lists = tmpLists
        appDelegate.saveContext()
    }
    
    func insertTodo(name:String, id:Int64, lists:[List], details:String?, startDate:Date?, dueDate:Date?) {
        print("DatabseManager::insertTodo(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let todoInsert = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context) as! Todo
        
        todoInsert.todoID = id
        todoInsert.name = name
        todoInsert.details = details
        todoInsert.dueDate = dueDate
        todoInsert.startDate = startDate
        
        appDelegate.saveContext()
    }
    
    //TODO: update methods
}


extension DatabaseManager { //Read methods
    
    //TODO: implement these methods & call them from all "writers" so they have the actual next valid ID number
    func getMaxListId() -> Int64 {
        return 0
    }
    func getMaxSmartListId() -> Int64 {
        return 0
    }
    func getMaxTodoId() -> Int64 {
        return 0
    }
    
    func getAllLists() -> [List] {
        let context = self.appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let lists = try context.fetch(listFetchRequest)
            print("DatabaseManager::getAllLists(): found \(lists.count) lists\n")
            return lists
        } catch {
            print("DatabaseManager::getAllLists(): error is \(error)")
            let tmpList:[List] = []
            return tmpList
        }
    }
    
    func getAllSmartLists() -> [SmartList] {
        let context = self.appDelegate.persistentContainer.viewContext
        let smartListFetchRequest: NSFetchRequest<SmartList> = SmartList.fetchRequest()
        do {
            let smartLists = try context.fetch(smartListFetchRequest)
            
            print("DatabaseManager::getAllSmartLists(): found \(smartLists.count) SmartLists\n")
            return smartLists
        } catch {
            print("DatabaseManager::getAllSmartLists(): error is \(error)")
            let tmpList:[SmartList] = []
            return tmpList
        }
    }
    
    //TODO: implement & add comments
    func getSmartListTodos(forSmartList: SmartList) -> [Todo] {
        return []
    }
    
    //TODO: use predicate instead?
    //TODO: add comments
    func getListTodos(forList list: List) -> [Todo] {
        //query for testing
        var todosInList:[Todo] = []
        var allTodos = self.getAllTodos()
            
        for todo in allTodos {
            if todo.lists!.contains(list) {
                todosInList.append(todo)
            }
        }

        return todosInList
    }
    
    //TODO: add comments
    func getAllTodos() -> [Todo] {
        let context = self.appDelegate.persistentContainer.viewContext
        
        var todos: [Todo] = []
        
        let todosFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            todos = try context.fetch(todosFetchRequest)
            
        } catch {
            print("DatabaseManager::getListTodos(): error is \(error)")
        }
        return todos
    }
    
    //TODO: implement & add comments
    func getAllTodos(where: String) -> [Todo] {
        var tmpList:[Todo] = []
        return tmpList
    }
}


