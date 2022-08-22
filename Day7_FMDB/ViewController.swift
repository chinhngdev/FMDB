//
//  ViewController.swift
//  Day7_FMDB
//
//  Created by Chinh Ng on 09/06/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var states: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        registerTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func configTableView() {
        title = "States"
        tableView.delegate = self
        tableView.dataSource = self
        }
        
    func registerTableViewCell() {
        let stateCell = UINib(nibName: "StateCell", bundle: nil)
        self.tableView.register(stateCell, forCellReuseIdentifier: "StateCell")
    }
    
    func fetchData() {
      states = DatabaseManager.shared.getListStates()
      tableView.reloadData()
    }
    
    @IBAction func addState(_ sender: UIBarButtonItem) {
        showAlert(title: "New State", message: "Enter info") { stateName, stateCode in
            self.save(stateName: stateName, stateCode: stateCode)
            self.tableView.reloadData()
        }
    }
    
    func update(stateName: String, stateCode: String, index: Int) {
      var state = states[index]
      state.stateName = stateName
      state.stateCode = stateCode
      state.modify()
      states[index] = state // do State là struct nên mỗi lần chạy hàm này sẽ sinh ra một bản ghi mới của state, cần phải có dòng này để update lại state trong mảng states trước khi reload TableView. Nếu State là class thì ko cần dòng này
      tableView.reloadData()
    }
    
    func save(stateName: String, stateCode: String) {
        var state = State()
        state.stateID = UUID().uuidString
        state.stateName = stateName
        state.stateCode = stateCode
        state.insertToDB()

        states.append(state)
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath) as! StateCell
        let state = states[indexPath.row]
        cell.stateName.text = state.stateName
        cell.stateCode.text = state.stateCode
        return cell
    }
    
    // MARK: - Swipe từ phải sang để xoá
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let state = states[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.states.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            state.delete()
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      showAlert(title: "Update", message: "Enter new info") {[weak self] stateName, stateCode in
          self?.update(stateName: stateName, stateCode: stateCode, index: indexPath.row)
//          self?.tableView.reloadData()
      }
    }
}

extension ViewController {
  func showAlert(title: String, message: String, saveCompletionHandler:((_ name: String, _ phone: String) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { action in

      guard let textField = alert.textFields?.first,
        let stateNameToSave = textField.text else {
          return
      }
      
      guard let textField = alert.textFields?[1],
        let stateCodeToSave = textField.text else {
          return
      }

      saveCompletionHandler?(stateNameToSave, stateCodeToSave)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addTextField { stateNameTxtField in
      stateNameTxtField.placeholder = "State name"
    }
    
    alert.addTextField { stateCodeTxtField in
      stateCodeTxtField.placeholder = "State code"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }
}

