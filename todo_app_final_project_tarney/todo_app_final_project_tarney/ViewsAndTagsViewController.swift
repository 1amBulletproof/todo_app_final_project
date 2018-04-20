//
//  ViewUITableViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/15/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class ViewsAndTagsViewController: UIViewController {

    let views = ["All", "Project Marzipan", "Today"]
    let tags = ["marzipan", "active"]
    
    @IBOutlet weak var viewsTable: UITableView!
    @IBOutlet weak var tagsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewsAndTags Controller INIT")
        
        self.viewsTable.delegate = self
        self.viewsTable.dataSource = self
        self.tagsTable.delegate = self
        self.tagsTable.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation/segues
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("segue is \(segue.identifier!)")
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
    
    
    @IBAction func unwindToTable(segue:UIStoryboardSegue)
    {
        print("transition unwind")
    }
}

    // MARK: - Table view data source
extension ViewsAndTagsViewController: UITableViewDataSource
{
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections")
        //TODO: return proper number of sections DEPENDING on the tableView passed-in
        if tableView == self.viewsTable {
            return 1
        } else { //tags table
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: return proper number of sections DEPENDING on the tableView passed-in
        print("titleForHeaderInSection")
        if tableView == self.viewsTable {
            return "Views"
        } else { //tags table
            return "Tags"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: properly populate data
        print("numberOfRowsInSection")
        if tableView == self.viewsTable {
            return self.views.count
        } else { // tags table
            return self.tags.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: properly populate data
        print("got here")
        if tableView == self.viewsTable {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ViewsCell", for: indexPath)
                    cell.textLabel?.text = self.views[indexPath.row]
                    return cell
        } else { // tags table
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagsCell", for: indexPath)
            cell.textLabel?.text = self.tags[indexPath.row]
            return cell
        }
    }
}


extension ViewsAndTagsViewController: UITableViewDelegate
{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt")
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("time to segue to this view or tag detail")
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("stuff")
        if editingStyle == .delete
        {
            //TODO: remove the deleted object from your data source.
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("touching accessory button")
//        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
////        performSegue(withIdentifier: "superHeroAccessorySegue", sender: self)
//        tableView.deselectRow(at: indexPath, animated: false)
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


