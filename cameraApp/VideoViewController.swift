//  VideoViewController.swift

import UIKit
import AVFoundation
import AssetsLibrary

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var index = 0
    
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
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
        self.startButton = UIButton(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        self.startButton.backgroundColor = UIColor.red;
        self.startButton.layer.masksToBounds = true
        self.startButton.layer.cornerRadius = 20.0
        self.startButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        self.startButton.addTarget(self, action: #selector(VideoViewController.onClickStartButton(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(self.startButton);
    }
    
    func onClickStartButton(_ sender: UIButton){
        var timer:Timer = Timer()
        
        if !self.isRecording {
            // start recording
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String = "\(documentsDirectory)/video\(self.index).mp4"
            let fileURL : URL = URL(fileURLWithPath: filePath)
            
            
            switch index {
            case 1:
                appDelegate.url1 = filePath
            case 2:
                appDelegate.url2 = filePath
            case 3:
                appDelegate.url3 = filePath
            default:
                print("Index is not defined.")
            }
            
            fileOutput.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
            
            self.isRecording = true
            self.changeButtonColor(self.startButton, color: UIColor.gray)
        
            timer = Timer.scheduledTimer(timeInterval: 5.0,
                                                           target: self,
                                                           selector: #selector(self.threeSecondsLater),
                                                           userInfo: nil,
                                                       repeats: false)
            }

    }
    
    func threeSecondsLater() {
        if self.isRecording {
            
            fileOutput.stopRecording()
            
            self.isRecording = false
            self.changeButtonColor(self.startButton, color: UIColor.red)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func changeButtonColor(_ target: UIButton, color: UIColor){
        target.backgroundColor = color
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        let assetsLib = ALAssetsLibrary()
        assetsLib.writeVideoAtPath(toSavedPhotosAlbum: outputFileURL, completionBlock: nil)
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
