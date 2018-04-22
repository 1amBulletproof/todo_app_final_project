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
        print("Initializing the DatabaseManager")
    }
    
}


extension DatabaseManager { //Write Methods
    
    func insertList(_ list: List) {
        print("DatabseManager inserting a List")
    }
    
    func insertSmartList(_ smartList: SmartList) {
        print("DatabseManager inserting a SmartList")
    }
    
    func insertTodo(_ todo: Todo) {
        print("DatabseManager inserting a Todo")
    }
    
    //TODO: update methods
}


extension DatabaseManager { //Read methods
    
    func getAllLists() -> [List] {

        let context = self.appDelegate.persistentContainer.viewContext
        let listFetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let lists = try context.fetch(listFetchRequest)
            print("DatabaseManager: getAllLists() found \(lists.count) lists\n")
            return lists
        } catch {
            print("DatabaseManager: getAllLists() error is \(error)")
            let tmpList:[List] = []
            return tmpList
        }
    }
    
    func getAllSmartLists() -> [SmartList] {

        let context = self.appDelegate.persistentContainer.viewContext
        let smartListFetchRequest: NSFetchRequest<SmartList> = SmartList.fetchRequest()
        do {
            let smartLists = try context.fetch(smartListFetchRequest)
            
            print("DatabaseManager: getALlSmartLists() found \(smartLists.count) SmartLists\n")
            return smartLists
        } catch {
            print("DatabaseManager: getAllSmartLists() error is \(error)")
            let tmpList:[SmartList] = []
            return tmpList
        }
    }
    
    func getAllTodos() -> [Todo] {
        var tmpList:[Todo] = []
        return tmpList
    }
    
    func getAllTodos(where: String) -> [Todo] {
        var tmpList:[Todo] = []
        return tmpList
    }
}


