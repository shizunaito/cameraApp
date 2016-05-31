//
//  ViewController2.swift
//  cameraApp
//
//  Created by 塚原健司 on 2016/05/19.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit

class itemInfoController: UIViewController,UITextFieldDelegate {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield2: UITextField!
    
    @IBAction func screentouch(sender: AnyObject) {
        self.view.endEditing(true)
        
        self.saveText()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        self.saveText()
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func backbtn(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfield1.delegate = self
        textfield2.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func saveText() {
        if (self.textfield1.text?.isEmpty) != nil || self.textfield1.text!.characters.count >= 6 {
            appDelegate.title = self.textfield1.text!
        }
        
        if (self.textfield2.text?.isEmpty) != nil || self.textfield2.text!.characters.count >= 6 {
            appDelegate.partNumber = self.textfield2.text!
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
