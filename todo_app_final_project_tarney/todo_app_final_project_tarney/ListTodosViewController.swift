//
//  ListsViewController
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/15/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//
import UIKit

class TodoRow : UITableViewCell {
    @IBOutlet weak var rowTodoNameLabel: UILabel!
    @IBOutlet weak var rowTodoDetailsButton: UIButton!
    @IBOutlet weak var rowTodoCompleteButton: UIButton!
}


class ListTodosViewController: UIViewController {
    
    let todos = ["todo1", "todo2", "todo3"]
    
    @IBOutlet weak var todosTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ListTodosViewController::viewDidLoad(): ViewsAndTags Controller INIT")
        
        self.todosTable.delegate = self
        self.todosTable.dataSource = self

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
        print("ListTodosViewController::prepareForSegue(): segue is \(segue.identifier!)")
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
extension ListTodosViewController: UITableViewDataSource
{
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        print("ListTodosViewController::numberOfSections(): 1")
        //TODO: return proper number of sections DEPENDING on the tableView passed-in
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: return proper number of sections DEPENDING on the tableView passed-in
        print("ListTodosViewController::titleForHeaderInSection(): Todos")
        return ("Todos")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: properly populate data
        print("ListTodosViewController::numberOfRowsInSection(): \(self.todos.count)")
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: properly populate data
        print("ListTodosViewController::cellForRowAt(): row \(indexPath.row)")
        if tableView == self.todosTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoRow", for: indexPath) as! TodoRow
            cell.rowTodoNameLabel.text = self.todos[indexPath.row]
            return cell
        } else { // tags table
            print("ListTodosViewController::cellForRowAt(): ERROR - not a todo row?!")
            return UITableViewCell()
        }
    }
}

extension ListTodosViewController: UITableViewDelegate
{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("ListTodosViewController::heightForRowAt() 50")
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("ListTodosViewController::didSelectRowAt(): selected row \(indexPath.row)")
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

