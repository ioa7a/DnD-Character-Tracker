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
    var expandCell: Bool = false
    var indexOfExpandedCell: Int = -1
    
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GeneralInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "generalInfoCell", for: indexPath) as! GeneralInfoTableViewCell
        
        cell.titleLabel?.text = abilityDescription[indexPath.row][0]
        cell.descriptionLabel?.text = abilityDescription[indexPath.row][1]
        cell.infoButton.setTitle("SHOW INFO", for: .normal)
        cell.infoButton.setTitle("HIDE INFO", for: .selected)
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(self.expandInformation(button:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if expandCell && indexPath.row == indexOfExpandedCell {
              if let cell = tableView.cellForRow(at: indexPath) as? GeneralInfoTableViewCell{
                return cell.descriptionLabel.bounds.size.height + 80.0
              }
              return 300.0
          }
        return 60.0
      }
    
    @objc func expandInformation(button: UIButton) {
        button.isSelected = !button.isSelected
        indexOfExpandedCell = button.tag
        expandCell = button.isSelected
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    
}
