//
//  AddDataControlelrViewController.swift
//  CoreToDo
//
//  Created by Binshad on 14/07/17.
//  Copyright © 2017 PmAbi. All rights reserved.
//

import UIKit

class AddDataControlelrViewController: UIViewController {

    @IBOutlet weak var dataOutlet: UITextField!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    let dataStorage = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveData(_ sender: Any) {
        
        if !((self.dataOutlet.text?.isEmpty)!){
        
            guard let taskDetails = self.dataOutlet.text else { return }
            let task = Task(context: context)
            task.name = taskDetails
            if self.switchOutlet.isOn{
                task.isImportant = "😰\(self.switchOutlet.isOn)"
            }else{
                task.isImportant = "🤤\(self.switchOutlet.isOn)"

            }
            
            dataStorage.saveContext()
            self.navigationController?.popViewController(animated: true)

        }else{
            
            postAlert(title: "InAdequate details Provided", message: "Please provide a data to save")
        
        }
        
        
        
        
        
    }
   

    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
