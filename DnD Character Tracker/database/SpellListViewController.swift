//
//  SpellListViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 10/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class SpellListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var spellTableView: UITableView!
    var expandCell: Bool = false
    var indexOfExpandedCell: Int = -1
    @IBOutlet weak var classPickerView: UIPickerView!
    var classPickerDataSource: [String] = ["Any Class", "Bard", "Cleric", "Druid", "Paladin", "Ranger", "Sorcerer", "Warlock", "Wizard"]
    var levelPickerDataSource: [String] = ["Any Level", "Cantrip", "Level 1", "Level 2",
                                           "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8", "Level 9"]
    var textFilter: String = ""
    var dataSource: [Spell] = []
    var filteredClass: String = "Any Class"
    var filteredLevel: String = "Any Level"
    @IBOutlet weak var filterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spellTableView.dataSource = self
        spellTableView.delegate = self
        searchBar.delegate = self
        classPickerView.delegate = self
        classPickerView.dataSource = self
        fetchData { (dict, error) in
            DispatchQueue.main.async {
                self.dataSource.sort(by: {$0.name < $1.name} )
                self.spellTableView.reloadData()
            }
        }
    }
    
    func fetchData(completion: @escaping ([Spell]?, Error?) -> Void) {
        for i in 1...7 {
            let url = URL(string: ("https://api.open5e.com/spells/?page=\(i)"))!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let results = json?["results"] as? NSArray
                    for i in 0 ..< results!.count {
                        let result = results![i] as? [String:Any]
                        let name = result?["name"] as! String
                        let desc = result?["desc"] as! String
                        let range = result?["range"] as! String
                        let duration = result?["duration"] as! String
                        let dndClass = result?["dnd_class"] as! String
                        let components = result?["components"] as! String
                        let materials = result?["material"] as! String
                        let higher_level =  result?["higher_level"] as! String
                        let level =  result?["level"] as! String
                        let casting_time =  result?["casting_time"] as! String
                        if (name.lowercased().contains(self.textFilter.lowercased()) || self.textFilter == "") && (dndClass.lowercased().contains(self.filteredClass.lowercased()) || self.filteredClass == "Any Class") && (self.filteredLevel == "Any Level" || level.lowercased().contains(self.filteredLevel.lowercased())) {
                            let spell = Spell(name: name, desc: desc, higher_level: higher_level, range: range, components: components, material: materials, duration: duration, casting_time: casting_time, level: level,  dnd_class: dndClass)
                            //  let spell = Spell(name: name , desc: desc, dnd_class: dndClass)
                            self.dataSource.append(spell)
                            
                        }
                    }
                    
                }
                completion(self.dataSource, nil)
                
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = spellTableView.dequeueReusableCell(withIdentifier: "spellCell") as? SpellTableViewCell {
            cell.spellNameLabel.text = dataSource[indexPath.row].name
            cell.classesLabel.text = dataSource[indexPath.row].dnd_class
            cell.descriptionLabel.text = "\(dataSource[indexPath.row].level) \nCasting Time: \(dataSource[indexPath.row].casting_time) \nRange: \(dataSource[indexPath.row].range) \nComponents: \(dataSource[indexPath.row].components)"
            if dataSource[indexPath.row].material != "" {
                cell.descriptionLabel.text?.append("\nMaterials: \(dataSource[indexPath.row].material)")
            }
            cell.descriptionLabel.text?.append("\nDuration: \(dataSource[indexPath.row].duration) \n\n\(dataSource[indexPath.row].desc) \n\(dataSource[indexPath.row].higher_level)")
            cell.infoButton.tag = indexPath.row
            cell.infoButton.addTarget(self, action: #selector(self.expandInformation(button:)), for: .touchUpInside)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandCell && indexPath.row == indexOfExpandedCell {
            if let cell = spellTableView.cellForRow(at: indexPath) as? SpellTableViewCell {
                return cell.descriptionLabel.bounds.size.height + 80.0
            }
            return 300.0
        }
        return 70.0
    }
    
    
    @objc func expandInformation(button: UIButton) {
        button.isSelected = !button.isSelected
        indexOfExpandedCell = button.tag
        expandCell = button.isSelected
        self.spellTableView.beginUpdates()
        self.spellTableView.endUpdates()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return classPickerDataSource.count }
        else {
            return levelPickerDataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return classPickerDataSource[row] }
        else {
            return levelPickerDataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            filteredClass = classPickerDataSource[row]
        }
        else {
            if row > 1 {
                filteredLevel = levelPickerDataSource[row].components(separatedBy: " ")[1]
            } else {
                filteredLevel = levelPickerDataSource[row]
            }
        }
     
    }


@IBAction func didPressFilterButton(_ sender: Any) {
    textFilter = searchBar.text ?? ""
    
    dataSource = []
    spellTableView.reloadData()
    
    fetchData { (dict, error) in
        DispatchQueue.main.async {
            self.dataSource.sort(by: {$0.name < $1.name} )
            self.dataSource.removeDuplicates()
            self.spellTableView.reloadData()
        }
    }
}

}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

func == (lhs: Spell, rhs: Spell) -> Bool {
    return lhs.name == rhs.name
}
