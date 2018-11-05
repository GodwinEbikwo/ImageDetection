//
//  ViewController2.swift
//  FinalProject
//
//  Created by Godwin Adejo Ebikwo on 05/10/2018.
//  Copyright © 2018 Godwin Adejo Ebikwo. All rights reserved.
//

import SpriteKit
import UIKit

class ViewController2: UIViewController
{
    @IBOutlet var edit: UITextField!
    @IBOutlet var button: UIButton!
    @IBOutlet var scroll: UIScrollView!
    
    var offset = CGFloat(20.0)
    
    class Sequencer
    {
        var counter: Double = 0.0
        var timer: Timer = Timer()
        var actions: Array<() -> ()> = []
        init() { self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true) }
        func run(_ actions: Array<() -> ()>) { self.actions.append(contentsOf: actions) }
        @objc func loop()
        {
            //debugPrint(self.counter) //Uncomment to watch the numbers count down in the console
            if(self.counter <= 0)
            {
                if(self.actions.count > 0)
                {
                    self.actions.first!() //Executes a list of instructions, just like a processor should ;)
                    _ = self.actions.removeFirst()
                }
            }
            else { self.counter -= 0.001 }
        }
        func wait(_ duration: Double) -> () -> () { return { self.counter = duration } }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.edit.isHidden = true
        self.button.isHidden = true
        self.button.layer.cornerRadius = self.button.frame.size.height / 2
        self.scroll.contentSize.height = self.scroll.visibleSize.height
        
        self.sequence1()
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated) }
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated) }
    
    //--Sequence--------------------------------------------------
    
    var sequencer: Sequencer = Sequencer()
    func sequence1() { self.sequencer.run([self.step1, sequencer.wait(2.0), self.step2]) }
    func sequence2() { self.sequencer.run([self.step5, sequencer.wait(2.0), self.step6, sequencer.wait(2.0), self.step7]) }
    func sequence3() { self.sequencer.run([self.step9, sequencer.wait(2.0), self.step10]) }
    
    func step1() { self.newMessage("Hello :)") }
    func step2()
    {
        self.newMessage("What's your name?")
        self.edit.addTarget(self, action: #selector(self.step3), for: .editingDidEndOnExit)
        self.edit.isHidden = false
    }
    @objc func step3(sender: AnyObject)
    {
        name = self.edit.text!
        self.edit.resignFirstResponder()
        self.edit.isHidden = true
        self.newMessage("Hey " + name + ", how are you?")
        self.setButtonTitle("I'm good, how are you?")
        self.button.addTarget(self, action: #selector(self.step4), for: .touchUpInside)
        self.button.isHidden = false
    }
    @objc func step4(sender: AnyObject) { self.sequence2() }
    func step5()
    {
        self.button.isHidden = true
        self.newMessage("I'm good, how are you?", otherSide: true)
    }
    func step6() { self.newMessage("I'm good too.") }
    func step7()
    {
        self.newMessage("Shall we see what AR can do?")
        self.setButtonTitle("Ok, let's go...😀")
        self.button.removeTarget(self, action: #selector(self.step4), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.step8), for: .touchUpInside)
        self.button.isHidden = false
    }
    @objc func step8(sender: AnyObject) { self.sequence3() }
    func step9()
    {
        self.button.isHidden = true
        self.newMessage("Ok, let's go 😀", otherSide: true)
    }
    func step10() { self.performSegue(withIdentifier: "showmeAR", sender: self) }
    
    //--Message---------------------------------------------------
    
    //Documentation: https://medium.com/@dima_nikolaev/creating-a-chat-bubble-which-looks-like-a-chat-bubble-in-imessage-the-easy-way-e6aa9180ef9a
    func newMessage(_ msg: String, otherSide: Bool = false)
    {
        let font = UIFont.systemFont(ofSize: 18)
        let constrain = CGSize(width: 0.66 * self.scroll.frame.width, height: .greatestFiniteMagnitude)
        let bbox = msg.boundingRect(with: constrain, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let label = UILabel()
        label.numberOfLines = 100
        label.font = font
        label.textColor = UIColor.white
        label.text = msg
        label.frame.size = CGSize(width: ceil(bbox.width), height: ceil(bbox.height))
        
        let size = CGSize(width: label.frame.width + 20, height: label.frame.height + 20)
        
        let bubble = UIImageView(frame: CGRect(
            x: self.scroll.frame.width - size.width - 20,
            y: self.scroll.frame.height - size.height - 20,
            width: size.width, height: size.height))
        bubble.image = UIImage(named: (otherSide == false) ? "incoming" : "outgoing")?
            .resizableImage(withCapInsets: UIEdgeInsets(
                top: 1, left: 1, bottom: 1, right: 1), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        bubble.tintColor = (otherSide == false)
           ? UIColor(red: 0.00, green: 0.69, blue: 0.94, alpha: 1.00)
           : UIColor(red: 0.00, green: 0.80, blue: 0.00, alpha: 1.00)
        
        bubble.center = CGPoint(x: ((otherSide == false) ? size.width / 2 : self.scroll.frame.width - size.width / 2),
                                y: self.offset + (size.height / 2))
        self.scroll.addSubview(bubble)
        label.center = bubble.center
        self.scroll.addSubview(label)
        self.offset += bubble.frame.height + 16
        self.scroll.contentSize.height = self.offset
        if(self.scroll.contentSize.height > self.scroll.bounds.size.height)
        {
            self.scroll.setContentOffset(CGPoint(x: 0, y: self.scroll.contentSize.height - self.scroll.bounds.size.height), animated: false)
        }
    }
    
    func setButtonTitle(_ Title: String)
    {
        self.button.setAttributedTitle(NSAttributedString(string: Title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
    }
}


