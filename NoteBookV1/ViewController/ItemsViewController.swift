//
//  ViewController.swift
//  NoteBookV1
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController{

    var items = [Items]()
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var seletedCategoris : Categories? {
        
        didSet{
             loadItem()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        
        
        cell.textLabel?.text=items[indexPath.row].title
           
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert=UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add ", style: .default) { (atction) in
            //what will happen when user presse the add new item button
            //print("succes!")
            
            let item=Items(context: self.context)
            item.title = textfield.text!
            item.done = false
            item.parentCategories = self.seletedCategoris
            self.items.append(item)
            
//            self.items.append(textfield.text!)
//            self.defauts.set(self.items, forKey: "TodoListArray")
            self.saveItem()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Creat new item"
            textfield = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        
        do {
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadItem(with request: NSFetchRequest<Items>=Items.fetchRequest(), predicate: NSPredicate? = nil ){
    
            let request:NSFetchRequest<Items>=Items.fetchRequest()
            
            let categoryPredicat = NSPredicate(format: "parentCategories.name MATCHES %@", seletedCategoris!.name!)
    
            if let addtionalPredicat = predicate {
    
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicat,addtionalPredicat])
    
            }else{
    
                request.predicate=categoryPredicat
            }
    
            do{
    
                items = try context.fetch(request)
    
            }catch{
                print("Error fetching data from context \(error)")
            }
            
            tableView.reloadData()
    }
}
    

extension ItemsViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Items>=Items.fetchRequest()
        
        //let predicator=NSPredicate(format: "title CONTAINS [cd] %@",searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
//            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
