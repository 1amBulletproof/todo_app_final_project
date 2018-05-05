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
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
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
    
    //MARK: - Button Callbacks
    @IBAction func selectList(_ sender: Any) {
        //TODO: need to use the actual NAME of the smart list, not the table row!
                //TODO: bind listID to "tag" of details & select buttons when they are created!
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
            cell.rowSmartListDetailButton.tag = Int(self.smartListsFromDB[indexPath.row].smartListID)
            cell.rowSmartListSelectButton.tag = Int(self.smartListsFromDB[indexPath.row].smartListID)
            return cell
        } else { // lists table
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath) as! ListRow
            cell.rowListNameLabel.text = self.listsFromDB[indexPath.row].name!
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
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            //TODO: remove the deleted object from your data source.
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}



