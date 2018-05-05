//
//  TodoNotesViewController.swift
//  todo_app_final_project_tarney
//
//  Created by Brandon Tarney on 4/21/18.
//  Copyright © 2018 Johns Hopkins University. All rights reserved.
//

import UIKit

class TodoNotesViewController: UIViewController, UITextViewDelegate {
    //MARK: - Class Properties
    @IBOutlet weak var todoNameText: UITextView!
    @IBOutlet weak var todoDetailsText: UITextView!
    
    var todoDetailsView: TodoDetailViewController!
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoDetailsText.delegate = self
        self.todoNameText.text = self.todoDetailsView.todoNameText.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.todoNameText.text = self.todoDetailsView.todoNameText.text
        self.todoDetailsText.text = self.todoDetailsView.todoDetailNotes
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.todoDetailsView.todoDetailNotes = textView.text
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
}
