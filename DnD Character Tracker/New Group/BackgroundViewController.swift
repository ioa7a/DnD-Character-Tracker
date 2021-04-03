//
//  BackgroundViewController.swift
//  abseil
//
//  Created by Ioana Bojinca on 01/01/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class BackgroundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var expandCell: Bool = false
    var indexOfExpandedCell: Int = -1
    var didSelectBg: Bool = false
    var raceIndex: Int = 0
    var classIndex: Int = 0
    var bgIndex: Int = 0
    var backgrounds : [Background] = []
    var selectedBackground: String?
    var ref: DatabaseReference = Database.database().reference()
    let user = Auth.auth().currentUser
    var charNumber: Int = 0;
    @IBOutlet weak var bgTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgTableView.dataSource = self
        bgTableView.delegate = self
        ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                      let value = snapshot.value as? NSDictionary
                      self.charNumber = Int(value?["character nr"] as! String) ?? 0
                  })
                  { (error) in
                      print(error.localizedDescription)
                  }
        
        for i in 1...13 {
            ref.child("backgrounds").child(String(i)).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String
                let desc = value?["description"] as? String
                let feature = value?["feature"] as? String
                let skills = value?["skills"] as? String
                let tools = value?["tools"] as? String
                let languageNumber = value?["languages"] as? String
                let bg = Background(name: name!, desc: desc!, skills: skills!, tools: tools!, languageNr: languageNumber!, feature: feature!)
                self.backgrounds.append(bg)
                self.bgTableView.reloadData()
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        if didSelectBg {
            self.ref.child("users").child(user!.uid).updateChildValues(["\(charNumber+1)/background" : selectedBackground!])
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProficienciesVC") as! ProficienciesViewController
            vc.raceIndex = raceIndex
            vc.bgIndex = bgIndex
            vc.classIndex = classIndex
            vc.charNumber = charNumber
            debugPrint("bg view index: \(classIndex) \(bgIndex)")
          
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "Please select a background for your character.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backgrounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = bgTableView.dequeueReusableCell(withIdentifier: "bgCell") as? BackgroundTableViewCell {
            cell.infoButton.isOpaque = true
            cell.infoButton.isHidden = false
            cell.nameLabel?.text = backgrounds[indexPath.row].name
            cell.descriptionLabel?.text = backgrounds[indexPath.row].desc
            cell.skillLabel.text = "Background skills: \(backgrounds[indexPath.row].skills ?? "none")"
            cell.featureLabel.text = "Background feature: \(backgrounds[indexPath.row].feature ?? "none")"
            cell.languageLabel.text = "Number of languages: \(backgrounds[indexPath.row].languageNr ?? "none")"
            cell.infoButton.tag = indexPath.row
            cell.infoButton.addTarget(self, action: #selector(self.expandInformation(button:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBackground = backgrounds[indexPath.row].name
        bgIndex = indexPath.row + 1
        didSelectBg = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandCell && indexPath.row == indexOfExpandedCell {
            if let cell = bgTableView.cellForRow(at: indexPath) as? BackgroundTableViewCell {
                          return cell.descriptionLabel.bounds.size.height + 66.0*5
                      }
            return 300.0
        }
        return 55.0
    }
    
    @objc func expandInformation(button: UIButton) {
        button.isSelected = !button.isSelected
        indexOfExpandedCell = button.tag
        expandCell = button.isSelected
        self.bgTableView.beginUpdates()
        self.bgTableView.endUpdates()
    }
    
    @IBAction func didPressPrevButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
