//
//  ViewController.swift
//  CoreToDo
//
//  Created by Binshad on 14/07/17.
//  Copyright © 2017 PmAbi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var tasks : [Task] = []
    let dataStorage =  UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let footerView = UIView()
        self.tableView.tableFooterView = footerView
        getData()
        self.tableView.reloadData()
        
        let backImage = UIImageView()
        backImage.image = UIImage(named: "nothing")
        if self.tasks.isEmpty{
            tableView.backgroundView?.isHidden = false
            tableView.backgroundView = backImage
        }else{
            tableView.backgroundView?.isHidden = true
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.detailTextLabel?.text = "\(tasks[indexPath.row].isImportant ?? "Default Value")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
                context.delete(tasks[indexPath.row])
                self.dataStorage.saveContext()
                
                self.tasks.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                tableView.reloadData()
        }
    }
    
    
    func getData(){
    
        do{
            tasks = try context.fetch(Task.fetchRequest())
            
        }catch let error{
            print("Error Occured in receieving the data from the model  : \(error.localizedDescription)")
        }
    }
    
    

}

