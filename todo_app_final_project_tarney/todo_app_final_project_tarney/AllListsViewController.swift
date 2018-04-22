//
//  ListsViewController
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/15/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit
import CoreData

class SmartListRow : UITableViewCell {
    @IBOutlet weak var rowSmartListNameLabel: UILabel!
    @IBOutlet weak var rowSmartListDetailButton: UIButton!
    @IBOutlet weak var rowSmartListSelectButton: UIButton!
}

class ListRow : UITableViewCell {
    @IBOutlet weak var rowListNameLabel: UILabel!
    @IBOutlet weak var rowListDetailsButton: UIButton!
    @IBOutlet weak var rowListSelectButton: UIButton!
}

class AllListsViewController: UIViewController {

    @IBOutlet weak var smartListsTable: UITableView!
    @IBOutlet weak var listsTable: UITableView!
    
    let dbManager = DatabaseManager()
    
    var appDelegate:AppDelegate!
    
    var smartListsFromDB: [SmartList] = []
    var listsFromDB:[List] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AllListsViewController::viewDidLoad(): Start")
        self.smartListsTable.delegate = self
        self.smartListsTable.dataSource = self
        self.listsTable.delegate = self
        self.listsTable.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.listsFromDB = dbManager.getAllLists()
        self.smartListsFromDB = dbManager.getAllSmartLists()
        self.smartListsTable.reloadData()
        self.listsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation/segues
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("AllListsViewController::prepareForSegue(): segue is \(segue.identifier!)")
        //        let indexPath = tableView.indexPathForSelectedRow!
        //        let section = indexPath.section
        //        let row = indexPath.row
        //
        //        let vc = segue.destination as! SuperHeroDetailViewController
        //        vc.imageName = images[section][row]
        //        vc.heroName = superheroes[section][row]
        //        vc.companyName = companies[section]
        //        vc.powers = descriptions[section][row]
    }

}

// MARK: - Table view data source
extension AllListsViewController: UITableViewDataSource
{
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        print("AllListsViewController::numberOfSections(): 1")
        //TODO: return proper number of sections DEPENDING on the tableView passed-in
        if tableView == self.smartListsTable {
            return 1
        } else { //tags table
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: return proper number of sections DEPENDING on the tableView passed-in

        if tableView == self.smartListsTable {
            print("AllListsViewController::titleForHeaderInSection(): Views")
            return "Views"
        } else { //lists table
            print("AllListsViewController::titleForHeaderInSection(): Tags")
            return "Tags"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: properly populate data
        if tableView == self.smartListsTable {
            print("AllListsViewController::numberOfRowsInSection(): \(self.smartListsFromDB.count)")
            return self.smartListsFromDB.count
        } else { // lists table
            print("AllListsViewController::numberOfRowsInSection(): \(self.listsFromDB.count)")
            return self.listsFromDB.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: properly populate data
        print("AllListsViewController::cellForRowAt(): start")
        if tableView == self.smartListsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmartListRow", for: indexPath) as! SmartListRow
            cell.rowSmartListNameLabel.text = self.smartListsFromDB[indexPath.row].name!
            return cell
        } else { // lists table
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath) as! ListRow
            cell.rowListNameLabel.text = self.listsFromDB[indexPath.row].name!
            return cell
        }
    }
}


extension AllListsViewController: UITableViewDelegate
{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("AllListsViewController::heightForRowAt(): 50")
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("AllListsViewController::didSelectRowAt(): start")
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



