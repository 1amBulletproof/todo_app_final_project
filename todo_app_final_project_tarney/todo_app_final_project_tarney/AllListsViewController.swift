//
//  ListsViewController
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/15/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Class SmartListRow
class SmartListRow : UITableViewCell {
    @IBOutlet weak var rowSmartListNameLabel: UILabel!
    @IBOutlet weak var rowSmartListDetailButton: UIButton!
    @IBOutlet weak var rowSmartListSelectButton: UIButton!
}

//MARK: - Class ListRow
class ListRow : UITableViewCell {
    @IBOutlet weak var rowListNameLabel: UILabel!
    @IBOutlet weak var rowListDetailsButton: UIButton!
    @IBOutlet weak var rowListSelectButton: UIButton!
}

//MARK: - Class AllListsViewController
class AllListsViewController: UIViewController {
    //MARK: - Class Properties
    //UI Elements
    @IBOutlet weak var smartListsTable: UITableView!
    @IBOutlet weak var listsTable: UITableView!
    //DB elements
    let dbManager = DatabaseManager()
    var smartListsFromDB: [SmartList] = []
    var listsFromDB:[List] = []
    var listSelected:GenericList!
    var smartListDetailsSelected:SmartList?
    var listDetailsSelected:List?
    
    //MARK:  - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("AllListsViewController::viewDidLoad(): Start")
        self.smartListsTable.delegate = self
        self.smartListsTable.dataSource = self
        self.listsTable.delegate = self
        self.listsTable.dataSource = self
        //allow editing the table
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.listsFromDB = dbManager.getAllLists()
        self.smartListsFromDB = dbManager.getAllSmartLists()
        for sm in self.smartListsFromDB {
//            print("AllLists::ViewWillAppear(): This Smart List has \(sm.lists!.count) lists")
        }
        self.smartListsTable.reloadData()
        self.listsTable.reloadData()
    }
    
    //Enable editing of multiple tables embedded in UIViewController
    override func setEditing(_ editing: Bool, animated: Bool) {
        let editStatus = navigationItem.rightBarButtonItem?.title
        if editStatus == "Edit" {
            self.smartListsTable.isEditing = true
            self.listsTable.isEditing = true
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.smartListsTable.isEditing = false
            self.listsTable.isEditing = false
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Button Callbacks
    @IBAction func selectSmartList(_ sender: Any) {
//        print("AllListsViewController::selectSmartList(): start")
        let selectButton = sender as! UIButton
        for smartList in self.smartListsFromDB {
            if smartList.smartListID == selectButton.tag {
//                print("SmartList list count = \(smartList.lists!.count)")
                self.listSelected = GenericList(smartList)
            }
        }
        performSegue(withIdentifier: "ShowListTodos", sender: nil)
    }
    
    //MARK: - GET LIST FCN's
    func getSmartList(forIndexPath: IndexPath) -> SmartList? {
        var returnSmartList: SmartList?
        let smartListRow = self.smartListsTable.cellForRow(at: forIndexPath) as! SmartListRow
        let smartListId = smartListRow.tag
        //        print("row \(forIndexPath.row), smartListId \(smartListId)")
        for smartList in self.smartListsFromDB {
            //            print("SmartListId = \(smartList.smartListID)")
            if smartList.smartListID == smartListId {
                returnSmartList = smartList
            }
        }
        return returnSmartList
    }
    
    func getSmartListIndex(forSmartList: SmartList) -> Int? {
        var indexOfSmartList: Int?
        var index = 0
        for smartList in self.smartListsFromDB {
            if forSmartList == smartList {
                indexOfSmartList = index
            }
            index = index + 1
        }
        return indexOfSmartList
    }
    
    func getList(forIndexPath: IndexPath) -> List? {
        var returnList: List?
        let listRow = self.listsTable.cellForRow(at: forIndexPath) as! ListRow
        let listId = listRow.tag
        //        print("row \(forIndexPath.row), ListId \(listId)")
        for list in self.listsFromDB {
            //            print("listId = \(list.listID)")
            if list.listID == listId {
                returnList = list
            }
        }
        return returnList
    }
    
    func getListIndex(forList: List) -> Int? {
        var indexOfList: Int?
        var index = 0
        for list in self.listsFromDB {
            if forList == list {
                indexOfList = index
            }
            index = index + 1
        }
        return indexOfList
    }
    
    //MARK: - Button Callbacks
    @IBAction func selectList(_ sender: Any) {
//        print("AllListsViewController::selectList(): start")
        let selectButton = sender as! UIButton
        for list in self.listsFromDB {
            if list.listID == selectButton.tag {
                self.listSelected = GenericList(list)
            }
        }
        performSegue(withIdentifier: "ShowListTodos", sender: nil)
    }
    
    @IBAction func selectSmartListDetails(_ sender: Any) {
        let smartListDetailButton = sender as! UIButton
        let smartListDetailId = smartListDetailButton.tag
        for smartList in self.smartListsFromDB {
            if smartList.smartListID == smartListDetailId {
                self.smartListDetailsSelected = smartList
            }
        }
        performSegue(withIdentifier: "ShowSmartListDetails", sender: nil)
    }
    
    @IBAction func selectListDetails(_ sender: Any) {
        let listDetailButton = sender as! UIButton
        let listDetailId = listDetailButton.tag
        for list in self.listsFromDB {
            if list.listID == listDetailId {
                self.listDetailsSelected = list
            }
        }
        performSegue(withIdentifier: "ShowListDetails", sender: nil)
    }
    
    // MARK: - Navigation/segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        print("AllListsViewController::prepareForSegue(): segue is \(segue.identifier!)")
        switch segue.identifier! {
        case "ShowListTodos":
//            print("segue is ShowListTodos")
            let todoList = segue.destination as! ListTodosViewController
            todoList.genericList = self.listSelected
            break
        case "ShowListDetails":
//            print("segue is ShowListDetails")
            let listDetailsView = segue.destination as! ListDetailViewController
            listDetailsView.listToUpdate = self.listDetailsSelected
            break
        case "ShowSmartListDetails":
//            print("segue is ShowSmartListDetails")
            let smartListDetailsView = segue.destination as! SmartListDetailViewController
            smartListDetailsView.smartListToUpdate = self.smartListDetailsSelected
            break
        default:
//            print("AllListsViewController::prepareFor(segue): segue is \(segue.identifier!)")
            break
        }
    }
}

// MARK: - Table DATA SRC
extension AllListsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.smartListsTable {
            return 1
        } else { //tags table
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.smartListsTable {
//            print("AllListsViewController::titleForHeaderInSection(): Views")
            return "Smart Lists"
        } else { //lists table
//            print("AllListsViewController::titleForHeaderInSection(): Tags")
            return "Lists"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.smartListsTable {
//            print("AllListsViewController::numberOfRowsInSection(): \(self.smartListsFromDB.count)")
            return self.smartListsFromDB.count
        } else { // lists table
//            print("AllListsViewController::numberOfRowsInSection(): \(self.listsFromDB.count)")
            return self.listsFromDB.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("AllListsViewController::cellForRowAt(): start")
        if tableView == self.smartListsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmartListRow", for: indexPath) as! SmartListRow
            cell.rowSmartListNameLabel.text = self.smartListsFromDB[indexPath.row].name!
            cell.tag = Int(self.smartListsFromDB[indexPath.row].smartListID)
            cell.rowSmartListDetailButton.tag = Int(self.smartListsFromDB[indexPath.row].smartListID)
            cell.rowSmartListSelectButton.tag = Int(self.smartListsFromDB[indexPath.row].smartListID)
            return cell
        } else { // lists table
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath) as! ListRow
            cell.rowListNameLabel.text = self.listsFromDB[indexPath.row].name!
            cell.tag = Int(self.listsFromDB[indexPath.row].listID)
            cell.rowListDetailsButton.tag = Int(self.listsFromDB[indexPath.row].listID)
            cell.rowListSelectButton.tag = Int(self.listsFromDB[indexPath.row].listID)
            return cell
        }
    }
}

//MARK: - Table DELEGATE
extension AllListsViewController: UITableViewDelegate
{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("AllListsViewController::heightForRowAt(): 50")
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        print("AllListsViewController::didSelectRowAt(): start")
        if tableView == self.smartListsTable {
//            print("selected smart list row \(indexPath.row)")
            let smartListOptional = self.getSmartList(forIndexPath: indexPath)
            if let smartListFound = smartListOptional {
                self.listSelected = GenericList(smartListFound)
                performSegue(withIdentifier: "ShowListTodos", sender: nil)
            }
        } else if tableView == self.listsTable {
//            print("select list row \(indexPath.row)")
            let listOptional = self.getList(forIndexPath: indexPath)
            if let listFound = listOptional {
                self.listSelected = GenericList(listFound)
                performSegue(withIdentifier: "ShowListTodos", sender: nil)
            }
        } else {
            print("_ERROR_AllListsViewController::didSelectRowAt(): Unknown table \(tableView)")
        }
    }
    
    //MARK: - DELETE functionality
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if tableView == self.smartListsTable {
                let smartListToDeleteOptional = self.getSmartList(forIndexPath: indexPath)
                if let smartListToDelete = smartListToDeleteOptional {
                    let indexOfSmartListToDeleteOptional = self.getSmartListIndex(forSmartList: smartListToDelete)
                    
                    if let indexOfSmartListToDelete = indexOfSmartListToDeleteOptional {
                        //Remove it from UI Table first
                        self.smartListsTable.deleteRows(at: [indexPath], with: .fade)
                        //Remove it from cache of smartLists next
                        self.smartListsFromDB.remove(at: indexOfSmartListToDelete)
                        //Remove it from the database last
                        self.dbManager.delete(smartList: smartListToDelete)
                    }
                }
                
            } else if tableView == self.listsTable {
                let listToDeleteOptional = self.getList(forIndexPath: indexPath)
                if let listToDelete = listToDeleteOptional {
                    let indexOfListToDeleteOptional = self.getListIndex(forList: listToDelete)
                    
                    if let indexOfListToDelete = indexOfListToDeleteOptional {
                        //Remove it from UI Table first
                        self.listsTable.deleteRows(at: [indexPath], with: .fade)
                        //Remove it from cache of smartLists next
                        self.listsFromDB.remove(at: indexOfListToDelete)
                        //Remove it from the database last
                        self.dbManager.delete(list: listToDelete)
                    }
                }
            } else {
                print("_ERROR_AllListsViewController::commitEdit(): Unknown table \(tableView)")
            }
        } //end DELETE functionality
    }
    
    //MARK: - REORDER functionality
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {}
    
}



