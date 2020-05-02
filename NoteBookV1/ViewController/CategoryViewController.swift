//
//  CategoryTableViewController.swift
//  NoteBookV1
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categorie = [Categories]()
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategory()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categorie.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text=categorie[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsViewController
        
        if let indexPath=tableView.indexPathForSelectedRow{
            
            destinationVC.seletedCategoris = categorie[indexPath.row]
        }
        
    }
    
    
    @IBAction func addCategorie(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new categorie", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            
            let newCategory = Categories(context:self.context)
            newCategory.name=textField.text
            self.categorie.append(newCategory)
            self.saveCategory()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField=field
            textField.placeholder="Add a new category"
        }
        
        present(alert, animated:true, completion: nil)
        
    }
    
    func saveCategory(){
        
                do{
                    try self.context.save()
                }catch{
                   print("Error saving categorie \(error)")
                }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do{
            
            categorie = try context.fetch(request)
        }catch{
            
            print("Error fetching data from context \(error) ")
        }
        
        
        tableView.reloadData()
    }
    
}
