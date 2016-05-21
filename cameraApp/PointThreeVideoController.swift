//
//  ViewController9.swift
//  cameraApp
//
//  Created by 塚原健司 on 2016/05/19.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit

class ViewController9: UIViewController {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    @IBAction func video1ButtonClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoVC = storyboard.instantiateViewControllerWithIdentifier("VideoViewController") as! VideoViewController
        
        videoVC.index = 3
        self.presentViewController(videoVC, animated: true, completion: nil)
        
    }

    @IBAction func backbtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(appDelegate.url3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
