//
//  CounterVC.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import UIKit

class CounterVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var presenter: CounterViewPresenterProtocol!

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    
    func setupViews() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        spiner.isHidden = false
        presenter.loadText()
    }
    
    @IBAction func reloadTapped(_ sender: Any) {
        spiner.isHidden = false
        presenter.loadText()
    }
    @IBAction func logoutTapped(_ sender: Any) {
        presenter.logout()
    }
}

extension CounterVC: CounterViewProtocol {
    
    func showText(sandboxText: SandboxText) {
        spiner.isHidden = true
        tableView.reloadData()
        textView.text = sandboxText.data
    }
    
    func showLoadError(alert: UIAlertController) {
        spiner.isHidden = true
        tableView.reloadData()
        present(alert, animated: true, completion: nil)
    }
        
}

extension CounterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.charactersOfText?.count ?? 0
        return presenter.countsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let curCount = presenter.countsArr[indexPath.row]
//        let key = presenter.characterCounts.keys[indexPath.row]
        cell.textLabel?.text = "\(curCount.key) -> \(curCount.value)"
        return cell
    }
}

