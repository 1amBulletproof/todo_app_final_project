//
//  GenericList.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/23/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import Foundation
import CoreData

//GenericList wraps EITHER a SmartList or List, but provides an API which works for BOTH
//  - useful for populating 1 View with EITHER a SmartList or List
class GenericList {
    
    var smartList:SmartList?
    var list:List?
    
    init(_ smartList: SmartList) {
        self.smartList = smartList
    }
    
    init(_ list: List) {
        self.list = list
    }
    
    func getTodos() -> [Todo] {
        let databaseManager = DatabaseManager()
        if let smartList = self.smartList {
            return databaseManager.getSmartListTodos(forSmartList: smartList)
        } else if let list = self.list {
            return databaseManager.getListTodos(forList: list)
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
