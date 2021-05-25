//
//  PrayerSettingsViewController.swift
//  Athany
//
//  Created by Seif Kobrosly on 1/11/21.
//

import Foundation
import UIKit



class PrayerSettingsViewController: UIViewController {
    fileprivate let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        self.setupTableView()
   
        // Do any additional setup after loading the view.
    }
    
    
    func setupTableView() {
      view.addSubview(tableView)
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}


extension PrayerSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
