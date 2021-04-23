//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/19.
//

import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var todo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let task = textView.text ?? ""
        todo = ToDo(task: task, category: .none)
    }

    func UpdateSaveButtonState() {
        let task = textView.text ?? ""
        saveButton.isEnabled = !task.isEmpty
    }
    
}
