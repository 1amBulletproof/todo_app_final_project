//
//  ListsViewController
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/15/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//
import UIKit

//MARK: - Class TodoRow
class TodoRow : UITableViewCell {
    @IBOutlet weak var rowTodoNameLabel: UILabel!
    @IBOutlet weak var rowTodoDetailsButton: UIButton!
    @IBOutlet weak var rowTodoCompleteButton: UIButton!
}

//MARK: - Class ListTodosViewController
class ListTodosViewController: UIViewController {
    //MARK: - Class Properties
    var genericList: GenericList!
    var selectedTodo:Todo?
    //db stuff
    let dbManager = DatabaseManager()
    var todosFromDB:[Todo] = []
    //UI Elements
    @IBOutlet weak var todosTable: UITableView!
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("ListTodosViewController::viewDidLoad(): ViewsAndTags Controller INIT")
        
        self.todosTable.delegate = self
        self.todosTable.dataSource = self
        //allow editing the table
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.todosFromDB = Array(self.genericList.getTodos())
        self.todosTable.reloadData()
    }
    
    //Enable editing of multiple tables embedded in UIViewController
    override func setEditing(_ editing: Bool, animated: Bool) {
        let editStatus = navigationItem.rightBarButtonItem?.title
        if editStatus == "Edit" {
            self.todosTable.isEditing = true
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.todosTable.isEditing = false
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - GET LIST FCN's
    func getTodo(forIndexPath: IndexPath) -> Todo? {
        var returnTodo: Todo?
        let todoRow = self.todosTable.cellForRow(at: forIndexPath) as! TodoRow
        let todoId = todoRow.tag
        //        print("row \(forIndexPath.row), todoID \(todoId)")
        for todo in self.todosFromDB {
            //            print("TodoID = \(todo.todoID)")
            if todo.todoID == todoId {
                returnTodo = todo
            }
        }
        return returnTodo
    }
    
    func getTodoIndex(forTodo: Todo) -> Int? {
        var indexOfTodo: Int?
        var index = 0
        for todo in self.todosFromDB {
            if forTodo == todo {
                indexOfTodo = index
            }
            index = index + 1
        }
        return indexOfTodo
    }
    
    //MARK: - Button Callback Methods
    @IBAction func todoDetailsButtonSelected(_ sender: Any) {
        let todoDetailButton = sender as! UIButton
        let todoID = todoDetailButton.tag
        for todo in self.todosFromDB {
            if todo.todoID == todoID {
                self.selectedTodo = todo
            }
        }
        performSegue(withIdentifier: "ShowTodoDetails", sender: nil)
    }
    
    @IBAction func completeTodo(_ sender: Any) {
        let completeTodoButton = sender as! UIButton
        let todoID = completeTodoButton.tag
        let rowNum = self.todosTable.indexPath(for: completeTodoButton.superview!.superview! as! UITableViewCell)
        
//        print("ListTodosViewController::completeTodo(): rowNum = \(rowNum)")
        for todo in self.todosFromDB {
            var counter = 0
            if todo.todoID == todoID {
                //Delete the todo from the db
                self.dbManager.delete(todo: todo)
                //Delete the todo in this UI cache
                self.todosFromDB.remove(at: counter)

                counter = counter + 1
            }
        }
        //Remove the cell
        self.todosTable.deleteRows(at: [rowNum!], with: .fade)
    }
    
    // MARK: - Navigation/segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        print("ListTodosViewController::prepareForSegue(): segue is \(segue.identifier!)")
        if segue.identifier! == "ShowTodoDetails" {
            let todoDetails = segue.destination as! TodoDetailViewController
            todoDetails.todoToUpdate = self.selectedTodo
        }
    }
}

// MARK: - Table DATA SOURCE
extension ListTodosViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
//        print("ListTodosViewController::numberOfSections(): 1")
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print("ListTodosViewController::titleForHeaderInSection(): Todos")
        return self.genericList.getName()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("ListTodosViewController::numberOfRowsInSection(): \(self.todosFromDB.count)")
        return self.todosFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("ListTodosViewController::cellForRowAt(): row \(indexPath.row)")
        if tableView == self.todosTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoRow", for: indexPath) as! TodoRow
            cell.rowTodoNameLabel.text = self.todosFromDB[indexPath.row].name
            cell.tag = indexPath.row
            cell.rowTodoCompleteButton.tag = Int(self.todosFromDB[indexPath.row].todoID)
            cell.rowTodoNameLabel.tag = Int(self.todosFromDB[indexPath.row].todoID)
            cell.rowTodoDetailsButton.tag = Int(self.todosFromDB[indexPath.row].todoID)
            return cell
        } else { // tags table
            print("ListTodosViewController::cellForRowAt(): ERROR - not a todo row?!")
            return UITableViewCell()
        }
    }
}

//MARK: - Table DELEGATE
extension ListTodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("ListTodosViewController::heightForRowAt() 50")
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //        print("ListTodosViewController::didSelectRowAt(): selected row \(indexPath.row)")
        let todoOptional = self.getTodo(forIndexPath: indexPath)
        if let todoFound = todoOptional {
            self.selectedTodo = todoFound
            performSegue(withIdentifier: "ShowTodoDetails", sender: nil)
        }

    }
    
    //MARK: - DELETE functionality
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let todoToDeleteOptional = self.getTodo(forIndexPath: indexPath)
            if let todoToDelete = todoToDeleteOptional {
                let indexOftodoToDeleteOptional = self.getTodoIndex(forTodo: todoToDelete)
                
                if let indexOftodoToDelete = indexOftodoToDeleteOptional {
                    //Remove it from UI Table first
                    self.todosTable.deleteRows(at: [indexPath], with: .fade)
                    //Remove it from cache of smartLists next
                    self.todosFromDB.remove(at: indexOftodoToDelete)
                    //Remove it from the database last
                    self.dbManager.delete(todo: todoToDelete)
                }
            }

        } //end DELETE functionality
    }
    
    //MARK: - REORDER functionality
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {}
}

