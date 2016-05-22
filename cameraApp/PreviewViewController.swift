//
//  PreviewViewController.swift
//  cameraApp
//
//  Created by 伊藤静那(Ito Shizuna) on 2016/05/21.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PreviewViewController: UIViewController {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var createCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.createCount == 0 {

            let path0 = self.appDelegate.introUrl
            let path1 = self.appDelegate.url1
            let path2 = self.appDelegate.url2
            let path3 = self.appDelegate.url3

            self.createCount = 1
            Composition.run([path0!, path1!, path2!, path3!], handler: {(url: NSURL) -> Void in
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    let vc: MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: url)
                    self.presentMoviePlayerViewControllerAnimated(vc)
                })
            })

        } else {
            let alertController = UIAlertController(title: "保存完了", message: "動画を保存しました", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "はい", style: .Default,
                                              handler:{
                                                (action:UIAlertAction!) -> Void in
                                                self.performSegueWithIdentifier("restart",sender: nil)

            })
            
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        print("再生完了")
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
