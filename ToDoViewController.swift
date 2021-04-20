//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/19.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveToDoTask(_ sender: Any) {
        let todoTask = textView.text
        
        userDefault.set(todoTask, forKey: "todoTask")
        userDefault.synchronize()
    }

}
