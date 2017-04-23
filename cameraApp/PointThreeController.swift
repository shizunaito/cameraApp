//
//  ViewController8.swift
//  cameraApp
//
//  Created by 塚原健司 on 2016/05/19.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit

class ViewController8: UIViewController,
UITextFieldDelegate {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate


    @IBAction func tapScreen(_ sender: AnyObject) {
        
        self.saveText()
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var threeCheckImg: UIImageView!
    @IBOutlet weak var textfield: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        self.saveText()
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func backbtn(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfield.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.pointThree != nil {
            self.threeCheckImg.image = UIImage(named: "checkmark-done")
        } else {
            self.threeCheckImg.image = UIImage(named: "checkmark")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func saveText() {
        if (self.textfield.text?.isEmpty) != nil || self.textfield.text!.characters.count >= 6 {
            appDelegate.pointThree = self.textfield.text!
            
            if appDelegate.pointOne != nil {
                self.threeCheckImg.image = UIImage(named: "checkmark-done")
            } else {
                self.threeCheckImg.image = UIImage(named: "checkmark")
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
