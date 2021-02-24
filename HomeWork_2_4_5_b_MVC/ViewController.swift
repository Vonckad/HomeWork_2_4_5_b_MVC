//
//  ViewController.swift
//  HomeWork_2_4_5_b_MVC
//
//  Created by Vlad Ralovich on 2/19/21.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private var realm: Realm!
    var todoList: Results<PersistanceRealm> {
        get { return realm.objects(PersistanceRealm.self)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        addButton.layer.cornerRadius = 30
        myTableView.rowHeight = 90
    }

// MARK: - Action
    @IBAction func addButtonAction(_ sender: Any) {
        initAlertView()
    }
    
    func initAlertView() {
        let alert = UIAlertController(title: "Новая задача", message: "", preferredStyle: .alert)
        alert.addTextField { textField in }
        
        let todoItemTextField = (alert.textFields?.first)! as UITextField
        let canceAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (addAlertButton) -> Void in
           
            let todoListItem = PersistanceRealm()
                            
            if let text = todoItemTextField.text {
                if text.count > 0 {
                todoListItem.name = text
                    try! self.realm.write({
                        self.realm.add(todoListItem)
                        self.myTableView.insertRows(at: [IndexPath(row: self.todoList.count - 1, section: 0)], with: .fade)
                    })
                }
            }
        }
        
        alert.addAction(canceAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - extension ViewController
extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write({
            realm.delete(todoList[indexPath.row])
        })
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].name
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 10
        cell.layer.borderColor = UIColor.systemGray4.cgColor
        
        return cell
    }
    
    // MARK: - animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        cell.layer.transform = animation
        cell.alpha = 0.33
        UIView.animate(withDuration: 0.7) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
