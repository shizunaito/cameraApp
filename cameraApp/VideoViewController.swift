//
//  VideoViewController.swift
//  cameraApp
//
//  Created by 伊藤静那(Ito Shizuna) on 2016/05/21.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var index = 0
    
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
    let fileOutput = AVCaptureMovieFileOutput()
    
    var startButton, stopButton : UIButton!
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do
        {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do
        {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice) as AVCaptureDeviceInput
            self.captureSession.addInput(audioInput)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.captureSession.addOutput(self.fileOutput)
        
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        self.setupButton()
        self.captureSession.startRunning()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButton(){
        self.startButton = UIButton(frame: CGRectMake(0,0,50,50))
        self.startButton.backgroundColor = UIColor.redColor();
        self.startButton.layer.masksToBounds = true
        self.startButton.layer.cornerRadius = 20.0
        self.startButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        self.startButton.addTarget(self, action: #selector(VideoViewController.onClickStartButton(_:)), forControlEvents: .TouchUpInside)
        
        
        self.view.addSubview(self.startButton);
    }
    
    func onClickStartButton(sender: UIButton){
        var timer:NSTimer = NSTimer()
        
        if !self.isRecording {
            // start recording
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String = "\(documentsDirectory)/video\(self.index).mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath)
            
            if index == 0 {
                appDelegate.introUrl = filePath
            } else if index == 1 {
                appDelegate.url1 = filePath
            } else if index == 2 {
                appDelegate.url2 = filePath
            } else if index == 3 {
                appDelegate.url3 = filePath
            } else if index == 4 {
                appDelegate.SumUrl = filePath
            }
            
            fileOutput.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
            
            self.isRecording = true
            self.changeButtonColor(self.startButton, color: UIColor.grayColor())
            
            if index == 0 {
                timer = NSTimer.scheduledTimerWithTimeInterval(2.0,
                                                               target: self,
                                                               selector: #selector(self.threeSecondsLater),
                                                               userInfo: nil,
                                                               repeats: false)
            } else {
                timer = NSTimer.scheduledTimerWithTimeInterval(5.0,
                                                           target: self,
                                                           selector: #selector(self.threeSecondsLater),
                                                           userInfo: nil,
                                                       repeats: false)
            }
        }
    }
    
    func threeSecondsLater() {
        if self.isRecording {
            
            fileOutput.stopRecording()
            
            self.isRecording = false
            self.changeButtonColor(self.startButton, color: UIColor.redColor())
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func changeButtonColor(target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        let assetsLib = ALAssetsLibrary()
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: nil)
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