//
//  GenericList.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/23/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.

//GenericList wraps EITHER a SmartList or List, but provides an API which works for BOTH
//  - useful for populating 1 View with EITHER a SmartList or List

import Foundation
import CoreData

class GenericList {
    //MARK: - Class Variables
    var smartList:SmartList?
    var list:List?
    
    //MARK: - Class Constructors
    init(_ smartList: SmartList) {
        self.smartList = smartList
//        print("I have \(self.smartList!.lists) lists")
    }
    
    init(_ list: List) {
        self.list = list
    }
    
    //MARK: - Class GETTERS
    func getTodos() -> Set<Todo> {
        let databaseManager = DatabaseManager()
        if let smartList = self.smartList {
//            print("I have \(smartList.lists!.count) lists")
            //get ALL the possible TODOs
            let allTodos = databaseManager.getAllTodosForListsIn(smartList: smartList)
            //Filter out TODOS which are in ALL SmartList lists
            var smartListTodos = Set<Todo>()
            let now = Date()
            for todo in allTodos {
                var addTodoToSmartListTodos = true
                for list in smartList.lists! {
                    if !(todo.lists!.contains(list)) {
                        addTodoToSmartListTodos = false
                    }
                }
                if (todo.startDate! >= now) {
                    addTodoToSmartListTodos = false
                }
                if addTodoToSmartListTodos {
                    smartListTodos.insert(todo)
                }
            }
            return smartListTodos
        } else if let list = self.list {
            let tmpSetTodos = self.list!.todos!
            return tmpSetTodos as! Set<Todo>
        } else {
            return []
        }
    }
    
    func getName() -> String {
        if let smartList = self.smartList {
            return smartList.name!
        } else if let list = self.list {
            return list.name!
        } else {
            return ""
        }
    }
    
    func getID() -> Int64 {
        if let smartList = self.smartList {
            return smartList.smartListID
        } else if let list = self.list {
            return list.listID
        } else {
            return -1
        }
    }

    
}
