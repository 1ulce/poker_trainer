//
//  QuizViewController.swift
//  GTO poker trainer
//
//  Created by 筑田駿 on 2019/03/06.
//  Copyright © 2019 Shun Tsukuda. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var Label00: UILabel!
    @IBOutlet weak var Label01: UILabel!
    @IBOutlet var Button01: [UIButton]!
    @IBOutlet weak var Progress: UIProgressView!
    
    var csvArray: [AnyObject] = []
    var quizNum = 0
    var pointSum = 0 as Double
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        csvToArray()
        showQuiz()
    }
    
    func csvToArray(){
        if let csvPath = Bundle.main.path(forResource: "mondai", ofType: "csv"){
            do{
                let csvStr = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
                let csvArr = csvStr.components(separatedBy: "\n")
                
                for csvFile in csvArr {
                    let csvSplit = csvFile.components(separatedBy: ",")
                    
                    csvArray.append(csvSplit as AnyObject)
                }
                //print(csvArr.count)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    
    func showQuiz() {
        if quizNum >= csvArray.count {
            let count: Double = Double(csvArray.count)
            let result = pointSum / count
            let strf: String = NSString(format: "%.2f", result) as String
            var rank = ""
            if result >= 80 {
                rank = "EXTRA TERRESTRIAL"
            } else if result >= 60 {
                rank = "WORLD CLASS"
            } else if result >= 40 {
                rank = "EXPART"
            } else if result >= 20 {
                rank = "INTERMEDIATE"
            } else {
                rank = "BEGGINER"
            }

            let alart = UIAlertController(title: "SB 3bet vs BTN quiz", message: strf + "点でした。\nあなたは\(rank)です。", preferredStyle: .alert)
            let action = UIAlertAction(title: "終了", style: .default, handler: {
                (_) in self.dismiss(animated: true, completion: nil)
            })
            alart.addAction(action)
            present(alart, animated: true, completion: nil)
            return
        }
        
        let quizData = csvArray[quizNum]
        Label00.text = "SB 3bet vs BTN\n第\(quizNum+1)問"
        Label01.text = quizData[0] as AnyObject as! String
        Progress.setProgress((Float(quizNum+1))/Float(csvArray.count),animated: true)
    }
    
    
    @IBAction func ButtonCheck(_ sender:Any){
        let b:UIButton = sender as! UIButton
        let answerNum = b.tag+2
        let pointStr = csvArray[quizNum][answerNum] as AnyObject as! String
        let point = pointStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let dNum: Double = NSString(string: point).doubleValue
        pointSum += dNum
        var message = point+"点"
        if point != "100.0" {
            for i in 0...3 {
                let somePointStr = csvArray[quizNum][i+3] as AnyObject as! String
                let somePoint = somePointStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                if somePoint == "100.0" {
                    var correctAnswer = ""
                    switch i {
                    case 0:
                        correctAnswer = "1.50 Pot bet"
                    case 1:
                        correctAnswer = "0.75 Pot bet"
                    case 2:
                        correctAnswer = "0.33 Pot bet"
                    default:
                        correctAnswer = "Check"
                    }
                    message = "\(point)点\n満点回答は\(correctAnswer)"
                }
            }
        }
        let alart = UIAlertController(title: "\(quizNum + 1)問目", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Go Next", style: .default, handler: {
            (_) -> Void in
                self.quizNum += 1
                self.showQuiz()
        })
        alart.addAction(action)
        present(alart, animated: true, completion: nil)
    }
}

