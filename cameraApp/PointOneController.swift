//
//  ViewController4.swift
//  cameraApp
//
//  Created by 塚原健司 on 2016/05/19.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit

class ViewController4: UIViewController,UITextFieldDelegate {

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var oneCheckImg: UIImageView!
    
    
    @IBAction func tabScreen(sender: AnyObject) {
        
        self.saveText()
        self.view.endEditing(true)
    }
    
    @IBAction func backbtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.pointOne != nil {
            self.oneCheckImg.image = UIImage(named: "checkmark-done")
        } else {
            self.oneCheckImg.image = UIImage(named: "checkmark")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        self.saveText()
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    private func saveText() {
        if (self.textfield.text?.isEmpty) != nil || self.textfield.text!.characters.count >= 6 {
            appDelegate.pointOne = self.textfield.text!
            
            if appDelegate.pointOne != nil {
                self.oneCheckImg.image = UIImage(named: "checkmark-done")
            } else {
                self.oneCheckImg.image = UIImage(named: "checkmark")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
