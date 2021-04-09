//
//  DiceRollViewController.swift
//  abseil
//
//  Created by Ioana Bojinca on 05/01/2021.
//



import UIKit

class DiceRollViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var totalValLabel: UILabel!
    @IBOutlet weak var rollButton: CustomButton!
    @IBOutlet weak var diceResultCollectionView: UICollectionView!
    @IBOutlet weak var diceNumberTextField: UITextField!
    @IBOutlet var diceType: [UIButton]!
    var howManyDice: Int = 0;
    var rolls: [Int] = []
    var cellRolls: [Int] = []
    var rollOK: Bool = false;
    var type: Int = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceNumberTextField.delegate = self
        diceResultCollectionView.delegate = self
        diceResultCollectionView.dataSource = self
        totalValLabel.text = "0"
    }
    
    @IBAction func didPressD4(_ sender: Any) {
        diceSelected(index: 0)
        type = 4;
    }
    
    @IBAction func didPressD6(_ sender: Any) {
        diceSelected(index: 1)
        type = 6;
        
    }
    @IBAction func didPressD8(_ sender: Any) {
        diceSelected(index: 2)
        type = 8;
    }
    
    @IBAction func didPressD10(_ sender: Any) {
        diceSelected(index: 3)
        type = 10;
        
    }
    @IBAction func didPressD12(_ sender: Any) {
        diceSelected(index: 4)
        type = 12;
    }
    
    @IBAction func didPressD20(_ sender: Any) {
        diceSelected(index: 5)
        type = 20;
    }
    
    @IBAction func didPressRollButton(_ sender: Any) {
        for i in 0..<diceType.count {
            if(diceType[i].isSelected){
                rollOK = true
                guard let diceNr = Int(diceNumberTextField.text!) else {
                    debugPrint("something went wrong")
                    return
                }
                
                if diceNr > 0 {
                    for _ in 0..<diceNr {
                        rolls.append(diceRoll(d: type))
                        diceResultCollectionView.reloadData()
                    }
                    
                }
                else {
                    let alert = UIAlertController(title: "Dice number must be greater than 0!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
                debugPrint("rolled \(rolls) ")
                break;
            }
        }
        if(!rollOK){
            debugPrint("select dice type!")}
        cellRolls = rolls
        rolls = []
        updateTotal()
        diceResultCollectionView.reloadData()
    }
    
    func diceSelected(index: Int) {
        diceType[index].isSelected = !diceType[index].isSelected
        if(diceType[index].isSelected){
            for i in 0...5 {
                if diceType[i].isSelected && i != index {
                    diceType[i].isSelected = false
                }
            }
        }
        else {
            for i in 0...5 {
                if diceType[i].isSelected && i != index {
                    diceType[i].isSelected = true
                }
            }
        }
    }
    
    func diceRoll (d: Int) -> Int {
        let number = Int.random(in: 1 ... d)
        return number
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellRolls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = diceResultCollectionView.dequeueReusableCell(withReuseIdentifier: "DiceCell", for: indexPath) as! DiceRollCollectionViewCell
        
        cell.diceLabel.text = String(cellRolls[indexPath.row])
        cell.diceLabel.isOpaque = true
        cell.diceLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        cell.diceLabel.isHidden = true
        cell.diceLabel.backgroundColor = .clear
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = 1
        rotation.isRemovedOnCompletion = true
        cell.diceImage.layer.add(rotation, forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.diceLabel.isHidden = false
        }
        switch(type){
        case 4: cell.diceImage.image = UIImage(named: "d4")
        case 6:         cell.diceImage.image = UIImage(named: "d6")
        case 8:       cell.diceImage.image = UIImage(named: "d8")
        case 10:       cell.diceImage.image = UIImage(named: "d10")
        case 12:      cell.diceImage.image = UIImage(named: "d12")
        case 20:       cell.diceImage.image = UIImage(named: "d20")
        default:      cell.diceImage.image = UIImage(named: "d6")
        }
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        diceNumberTextField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    func updateTotal(){
        var sum : Int = 0;
        for i in 0..<cellRolls.count {
            sum = sum + cellRolls[i]
        }
        totalValLabel.text = String(sum)
        
    }
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
