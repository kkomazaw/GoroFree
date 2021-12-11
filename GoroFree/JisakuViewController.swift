//
//  JisakuViewController.swift
//  GoroFree
//
//  Created by Matsui Keiji on 2019/07/26.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class JisakuViewController: UIViewController {
    
    @IBOutlet var KanryoButton:UIBarButtonItem!
    @IBOutlet var EnglishField:UITextField!
    @IBOutlet var JapaneseField:UITextField!
    @IBOutlet var GoroField:UITextField!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedArray = [GoroData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isJisakuKanryo = false
        EnglishField.becomeFirstResponder()
    }//override func viewDidLoad()
    
    func clearField(){
        EnglishField.text = ""
        JapaneseField.text = ""
        GoroField.text = ""
        EnglishField.becomeFirstResponder()
    }
    
    @IBAction func myActionKanryo(){
        var english = EnglishField.text ?? ""
        let japanese = JapaneseField.text ?? ""
        let goro = GoroField.text ?? ""
        guard !english.isEmpty, !japanese.isEmpty, !goro.isEmpty else {
            return
        }
        while english.hasSuffix(" ") {
            english = String(english.dropLast())
        }
        EnglishField.text = english
        do{
            let fetchRequest:NSFetchRequest<GoroData> = GoroData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format:"english = %@", english)
            fetchedArray = try myContext.fetch(fetchRequest)
        }
        catch{
            print("fetching failed")
        }
        if fetchedArray.count > 0 {
            let alert = UIAlertController(title: "重複", message: "この単語はすでに登録されています。\n新しい語呂で置き換えますか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
                self.fetchedArray[0].english = english
                self.fetchedArray[0].japanese = japanese
                self.fetchedArray[0].goro = goro
                self.fetchedArray[0].isOboeta = false
                self.fetchedArray[0].isJisaku = true
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            })//let okAction = UIAlertAction(
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }//if fetchedArray.count > 0
        else {
            let alert = UIAlertController(title: "保存完了", message: "自作語呂が保存されました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
                let goroData = GoroData(context: self.myContext)
                goroData.english = english
                goroData.pronounce = "省略"
                goroData.japanese = japanese
                goroData.goro = goro
                goroData.reibun = ""
                goroData.isOboeta = false
                goroData.isJisaku = true
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }))
            self.present(alert, animated: true, completion: nil)
        }//else
        isJisakuKanryo = true
        //clearField()
    }//@IBAction func myActionKanryo()
    
}//class JisakuViewController: UIViewController
