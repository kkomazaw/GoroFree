//
//  SubViewController.swift
//  GoroFree
//
//  Created by Matsui Keiji on 2019/07/26.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class SubViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var english = ""
    var pronounce = ""
    var japanese = ""
    var goro = ""
    var reibun = ""
    
    let synthesizer = AVSpeechSynthesizer()
    var speechText = [String]()
    var speechCounter = 0
    
    @IBOutlet var English:UILabel!
    @IBOutlet var Pronounce:UILabel!
    @IBOutlet var Japanese:UILabel!
    @IBOutlet var Goro:UILabel!
    @IBOutlet var Reibun:UILabel!
    @IBOutlet var oboetaSelector:UISegmentedControl!
    @IBOutlet var favoriteButton:UIBarButtonItem!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        English.text = "英単語: " + english
        Pronounce.text = "発音: [ " + pronounce + " ]"
        Japanese.text = "日本語: " + japanese
        Goro.text = "語呂: " + goro
        Reibun.text = reibun
        speechText = [
            english,
            japanese,
            goro,
            reibun
        ]
        do {
            let fetchRequest: NSFetchRequest<GoroData> = GoroData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K = %@", "english", english)
            let fetchResult = try myContext.fetch(fetchRequest)
            if fetchResult[0].isOboeta {
                oboetaSelector.selectedSegmentIndex = 1
            }
            else {
                oboetaSelector.selectedSegmentIndex = 0
            }
            if fetchResult[0].isJisaku {
                favoriteButton.title = "★favorite"
            }
            else {
                favoriteButton.title = "☆favorite"
            }
        }//do
        catch {
            print("Fetching Failed.")
        }//catch
    }//override func viewDidLoad()
    
    @IBAction func oboetaSelectorChanged(){
        do {
            let fetchRequest: NSFetchRequest<GoroData> = GoroData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "english = %@", english)
            let fetchResult = try myContext.fetch(fetchRequest)
            if oboetaSelector.selectedSegmentIndex == 0 {
                fetchResult[0].isOboeta = false
            }
            else {
                fetchResult[0].isOboeta = true
            }
        }//do
        catch {
            print("Fetching Failed.")
        }//catch
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }//@IBAction func oboetaSelectorChanged()
    
    @IBAction func favoriteButtonPushed(){
        do {
            let fetchRequest: NSFetchRequest<GoroData> = GoroData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "english = %@", english)
            let fetchResult = try myContext.fetch(fetchRequest)
            if fetchResult[0].isJisaku {
                fetchResult[0].isJisaku = false
                favoriteButton.title = "☆favorite"
            }
            else {
                fetchResult[0].isJisaku = true
                favoriteButton.title = "★favorite"
            }
        }//do
        catch {
            print("Fetching Failed.")
        }//catch
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }//@IBAction func favoriteButtonPushed()
    
    @IBAction func allYomiage(){
        speechCounter = 0
        speech(text: speechText[0])
    }
    
    @IBAction func englishYomiage(){
        speechCounter = 0
        speech(text: speechText[0])
        speechCounter = 3
    }
    
    @IBAction func japaneseYomiage(){
        speechCounter = 1
        speech(text: speechText[1])
        speechCounter = 3
    }
    
    @IBAction func goroYomiage(){
        speechCounter = 2
        speech(text: speechText[2])
        speechCounter = 3
    }
    
    @IBAction func reibunYomiage(){
        speechCounter = 3
        speech(text: speechText[3])
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechCounter += 1
        if speechCounter < speechText.count {
            speech(text: speechText[speechCounter])
        }
    }
    
    func speech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        switch speechCounter {
        case 0, 3:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        case 1, 2:
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        default:
            break
        }
        synthesizer.speak(utterance)
    }
    
}//class SubViewController: UIViewController
