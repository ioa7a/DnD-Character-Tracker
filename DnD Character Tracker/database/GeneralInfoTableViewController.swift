//
//  GeneralInfoTableViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 06/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class GeneralInfoTableViewController: UITableViewController {
    
    var abilityDescription: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abilityDescription = abilityDescription.sorted{$0[0]<$1[0]}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityDescription.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "generalInfoCell", for: indexPath)
        
        cell.textLabel?.text = abilityDescription[indexPath.row][0]
        cell.detailTextLabel?.text = abilityDescription[indexPath.row][1]
        
        return cell
    }
    
    
    
}
