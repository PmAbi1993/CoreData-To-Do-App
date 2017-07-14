//
//  SearchController.swift
//  CoreToDo
//
//  Created by Binshad on 14/07/17.
//  Copyright © 2017 PmAbi. All rights reserved.
//

import UIKit
import CoreData

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var querryOutlet: UITextField!
    
    let nilString = "|-*-|"
    
    var contents : [Task] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataStorage = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.querryOutlet.delegate = self
        self.querryOutlet.addTarget(self, action: #selector(getUserInput), for: .editingChanged)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let footer = UIView()
        self.tableView.tableFooterView = footer
    }
    @IBAction func searchForData(_ sender: Any) {
        
        self.contents = []
        
        let searchString = getSearchString()
        
        if (searchString == nilString)
        {
            postAlert(title: "Invalid querry", message: "Please input a vaslid querry")
            
        }else{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//            request.predicate = NSPredicate(format: " name == %@ ", searchString) /* ---- This provides a return of exact searchstring */
            request.predicate = NSPredicate(format: " name CONTAINS[cd] %@ ", searchString)

            
            do{
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    
                    for result in results {
                        if let conformedResult = result as? Task{
                            self.contents.append(conformedResult)
                            tableView.reloadData()
                        }else{
                            
                            self.contents = []
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }else{
                    postAlert(title: "No records visible", message: "The searched item is not visible inside the coredata stack")
                }
            }catch let error{
                print("Error in findignt he objecrt from the coredata stackabse : \(error.localizedDescription)")
            }
        }
        
    }
    @IBAction func fetchAll(_ sender: Any) {
        
        self.contents = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do{
            let results = try context.fetch(request)
            
            for result in (results as? [Task])!{
                
                self.contents.append(result)
                self.tableView.reloadData()
                
            }
            
            
            
        }catch let error{
            print("Error in obtaining results from core data Stack : \(error.localizedDescription)")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.contents[indexPath.row].name
        cell.detailTextLabel?.text = self.contents[indexPath.row].isImportant
        
        return cell
    }
    
    func getSearchString() -> String{
        
        if !((self.querryOutlet.text?.isEmpty)!){
            
            if let searchString = self.querryOutlet.text{
                return searchString
            }else{
                return nilString
            }
        }else{
            return nilString
        }
        
    }
    
    func getUserInput(textfield : UITextField){
        
        self.contents = []
        
        let searchString = getSearchString()
        
        if (searchString == nilString)
        {
            self.contents = []
            self.tableView.reloadData()
            
        }else{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            //            request.predicate = NSPredicate(format: " name == %@ ", searchString) /* ---- This provides a return of exact searchstring */
            request.predicate = NSPredicate(format: " name CONTAINS[cd] %@ ", searchString)
            
            
            do{
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    
                    for result in results {
                        if let conformedResult = result as? Task{
                            self.contents.append(conformedResult)
                            tableView.reloadData()
                        }
                        
                    }
                    
                }else{
                    self.contents = []
                    self.tableView.reloadData()
                }
            }catch let error{
                print("Error in findignt he objecrt from the coredata stackabse : \(error.localizedDescription)")
            }
        }

        
    
    }
    
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
