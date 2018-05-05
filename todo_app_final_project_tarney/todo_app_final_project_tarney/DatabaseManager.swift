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
    //MARK: - Class Properties
    var appDelegate:AppDelegate
    
    //MARK: - Class Constructor
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
//        print("DatabaseManager::init(): Initializing the DatabaseManager")
    }
}

//MARK: - Write Methods
extension DatabaseManager {
    
    //**Reminder** cannot instantiate database classes like var list = List()
    //  thus instead of passing-in a List, pass-in the necessary variables
    
    //MARK: - Insert Methods
    func insertList(name:String, id:Int64, todos:[Todo]) {
//        print("DatabseManager::insertList(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let listInsert = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        
        listInsert.listID = id
        listInsert.name = name
        listInsert.addToTodos(NSSet(array:todos))

        appDelegate.saveContext()
    }
    
    func insertSmartList(name:String, id:Int64, lists:[List]) {
//        print("DatabseManager::insertSmartList(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let smartListInsert = NSEntityDescription.insertNewObject(forEntityName: "SmartList", into: context) as! SmartList
        
        smartListInsert.name = name
        smartListInsert.smartListID = id
        smartListInsert.addToLists(NSSet(array: lists))

        appDelegate.saveContext()
    }
    
    func insertTodo(name:String, id:Int64, lists:[List], details:String?, startDate:Date?, dueDate:Date?) {
//        print("DatabseManager::insertTodo(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let todoInsert = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context) as! Todo
        
        todoInsert.todoID = id
        todoInsert.name = name
        todoInsert.details = details
        todoInsert.dueDate = dueDate
        todoInsert.startDate = startDate
        
        for list in lists {
            list.addToTodos(todoInsert)
        }
        
        appDelegate.saveContext()
    }
    
    //MARK: - update methods
    func update(todo: Todo) {
//        print("DatabseManager::update(Todo): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let todoInsert = self.getTodo(id: todo.todoID)
        if let todoToUpdate = todoInsert {
            todoToUpdate.todoID = todo.todoID
            todoToUpdate.name = todo.name
            todoToUpdate.details = todo.details
            todoToUpdate.dueDate = todo.dueDate
            todoToUpdate.startDate = todo.startDate
            
            appDelegate.saveContext()
        }
    }
    func updateTodo(name:String,
                    id:Int64,
                    lists:[List],
                    details:String?,
                    startDate:Date?,
                    dueDate:Date?) {
//        print("DatabseManager::update(Todo): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let todoInsert = self.getTodo(id: id)
        if let todoToUpdate = todoInsert {
            todoToUpdate.todoID = id
            todoToUpdate.name = name
            todoToUpdate.details = details
            todoToUpdate.dueDate = dueDate
            todoToUpdate.startDate = startDate
            
            appDelegate.saveContext()
        }
    }
    
    func update(list: List) {
//        print("DatabseManager::update(Todo): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let listInsert = self.getList(id: list.listID)
        if let listToUpdate = listInsert {
            listToUpdate.listID = list.listID
            listToUpdate.name = list.name
            listToUpdate.todos = list.todos
            
            appDelegate.saveContext()
        }
    }
    func updateList(name:String, id:Int64, todos:[Todo]) {
//        print("DatabseManager::update(Todo): start")

        let context = self.appDelegate.persistentContainer.viewContext
        let listInsert = self.getList(id: id)
        if let listToUpdate = listInsert {
            listToUpdate.listID = id
            listToUpdate.name = name
            let tmpTodos = NSSet(array: todos)
            listToUpdate.todos = tmpTodos
            
            appDelegate.saveContext()
        }
    }
    
    func update(smartList: SmartList) {
//        print("DatabseManager::updateSmartList(): start")
        
        let context = self.appDelegate.persistentContainer.viewContext
        let smartListInsert = self.getSmartList(id: smartList.smartListID)
        
        if let smartListToUpdate = smartListInsert {
            smartListToUpdate.name = smartList.name
            smartListToUpdate.smartListID = smartList.smartListID
            smartListToUpdate.lists = smartList.lists
            
            appDelegate.saveContext()
        }
    }
    func updateSmartList(name:String, id:Int64, lists:[List]) {
//        print("DatabseManager::updateSmartList(): start")

        let context = self.appDelegate.persistentContainer.viewContext
        let smartListInsert = self.getSmartList(id: id)
        
        if let smartListToUpdate = smartListInsert {
            smartListToUpdate.name = name
            smartListToUpdate.smartListID = id
            let tmpLists = NSSet(array: lists)
            smartListToUpdate.lists = tmpLists
            
            appDelegate.saveContext()
        }
    }
    
    //MARK: - Delete methods
    func delete(todo: Todo) {
        let context = self.appDelegate.persistentContainer.viewContext
        context.delete(todo)
    }
    
    func delete(list: Todo) {
        let context = self.appDelegate.persistentContainer.viewContext
        context.delete(list)
    }
    
    func delete(smartList: Todo) {
        let context = self.appDelegate.persistentContainer.viewContext
        context.delete(smartList)
    }
}


//MARK: - Read Methods
extension DatabaseManager {
    
    //MARK: - GET Single Obj
    func getTodo(id: Int64) -> Todo? {
        var todo:Todo?
        
        let context = appDelegate.persistentContainer.viewContext
        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        let idString = String(id)
        let predicate = NSPredicate(format: "todoID == %@", idString )
        todoFetchRequest.predicate = predicate
        
        do {
            var todos = try context.fetch(todoFetchRequest)
            if todos.count > 0 {
                todo = todos[0]
                if todos.count > 1 {
                    print("DatabaseManager::getList(id): found \(todos.count) Todos w/ id \(id)")
                }
            }
        } catch {
            print("DatabaseManager::getList(id):: error is \(error)")
        }
        
        return todo
    }
    
    func getTodo(named: String) -> Todo? {
        var todo:Todo?
        
        let context = appDelegate.persistentContainer.viewContext
        let todoFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@", named )
        todoFetchRequest.predicate = predicate
        
        do {
            var todos = try context.fetch(todoFetchRequest)
            if todos.count > 0 {
                todo = todos[0]
                if todos.count > 1 {
                    print("DatabaseManager::getList(id): found \(todos.count) Todos named \(named)")
                }
            }
        } catch {
            print("DatabaseManager::getList(id):: error is \(error)")
        }
        
        return todo
    }
    
    func getList(id: Int64) -> List? {
        var list:List?
        
        let context = appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        
        let idString = String(id)
        let predicate = NSPredicate(format: "listID == %@", idString )
        listFetchRequest.predicate = predicate
        
        do {
            var lists = try context.fetch(listFetchRequest)
            if lists.count > 0 {
                list = lists[0]
                if lists.count > 1 {
                    print("DatabaseManager::getList(id): found \(lists.count) Lists w/ id \(id)")
                }
            }
        } catch {
            print("DatabaseManager::getList(id):: error is \(error)")
        }
        
        return list
    }
    
    func getList(named: String) -> List? {
        var list:List?
        
        let context = appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@", named )
        listFetchRequest.predicate = predicate
        
        do {
            var lists = try context.fetch(listFetchRequest)
            if lists.count > 0 {
                list = lists[0]
                if lists.count > 1 {
                    print("DatabaseManager::getList(id): found \(lists.count) Lists named \(named)")
                }
            }
        } catch {
            print("DatabaseManager::getList(id):: error is \(error)")
        }
        
        return list
    }
    
    func getSmartList(id: Int64) -> SmartList? {
        var smartList:SmartList?
        
        let context = appDelegate.persistentContainer.viewContext
        let smartListFetchRequest: NSFetchRequest<SmartList> = SmartList.fetchRequest()
        
        let idString = String(id)
        let predicate = NSPredicate(format: "smartListID == %@", idString )
        smartListFetchRequest.predicate = predicate
        
        do {
            var smartLists = try context.fetch(smartListFetchRequest)
            if smartLists.count > 0 {
                smartList = smartLists[0]
                if smartLists.count > 1 {
                    print("DatabaseManager::getSmartList(id): found \(smartLists.count) SmartLists w/ id \(id)")
                }
            }
        } catch {
            print("DatabaseManager::getSmartList(id): error is \(error)")
        }
        
        return smartList
    }
    
    func getSmartList(named: String) -> SmartList? {
        var smartList:SmartList?
        
        let context = appDelegate.persistentContainer.viewContext
        let smartListFetchRequest: NSFetchRequest<SmartList> = SmartList.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@", named )
        smartListFetchRequest.predicate = predicate
        
        do {
            var smartLists = try context.fetch(smartListFetchRequest)
            if smartLists.count > 0 {
                smartList = smartLists[0]
                if smartLists.count > 1 {
                    print("DatabaseManager::getSmartList(named): found \(smartLists.count) SmartLists named \(named)")
                }
            }
        } catch {
            print("DatabaseManager::getSmartList(named): error is \(error)")
        }
        
        return smartList
    }
    
    //MARK: - GET ALL Obj
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
    
    func getAllLists() -> [List] {
        let context = self.appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let lists = try context.fetch(listFetchRequest)
//            print("DatabaseManager::getAllLists(): found \(lists.count) lists\n")
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
            
//            print("DatabaseManager::getAllSmartLists(): found \(smartLists.count) SmartLists\n")
            return smartLists
        } catch {
            print("DatabaseManager::getAllSmartLists(): error is \(error)")
            let tmpList:[SmartList] = []
            return tmpList
        }
    }
    
    //MARK: - GET Max ID
    func getMaxListId() -> Int64 {
        var maxListId: Int64 = 0
        let allLists = self.getAllLists()
        for list in allLists {
            if list.listID > maxListId {
                maxListId = list.listID
            }
        }
        return maxListId
    }
    
    func getMaxSmartListId() -> Int64 {
        var maxSmartListId: Int64 = 0
        let allLists = self.getAllSmartLists()
        for smartList in allLists {
            if smartList.smartListID > maxSmartListId {
                maxSmartListId = smartList.smartListID
            }
        }
        return maxSmartListId
    }
    
    func getMaxTodoId() -> Int64 {
        var maxTodoId: Int64 = 0
        let allTodos = self.getAllTodos()
        for todo in allTodos {
            if todo.todoID > maxTodoId {
                maxTodoId = todo.todoID
            }
        }
        return maxTodoId
    }
    
    //MARK: - GET SOME Obj
    func getSmartListTodos(forSmartList: SmartList) -> Set<Todo>{
        //query for testing
        var todosInList:Set<Todo> = []
        for list in forSmartList.lists! {
            let tmpList = list as! List
            let tmpSetTodo: Set<Todo> = tmpList.todos! as! Set<Todo>
            todosInList = todosInList.union(tmpSetTodo)
        }
        
        return todosInList
    }
    
    func getAllTodos(forExpression: String) -> [Todo] {
        var allTodos:[Todo] = []
        
        let context = self.appDelegate.persistentContainer.viewContext
        
        let todosFetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: forExpression)
        todosFetchRequest.predicate = predicate
        
        do {
            allTodos = try context.fetch(todosFetchRequest)
//            print("DatabaseManager::getListTodos(forExpression): found \(allTodos.count) todos")
        } catch {
            print("DatabaseManager::getListTodos(forExpression): error is \(error)")
        }
        return allTodos
    }
}


