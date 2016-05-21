//
//  Composition.swift
//  cameraApp
//
//  Created by 伊藤静那(Ito Shizuna) on 2016/05/21.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Composition: NSObject {

    var url1: String!
    var url2: String!
    var url3: String!

    func create(handler: (url: NSURL) -> Void) {
        
        print(url1!)
        print(url2!)
        print(url3!)
        
        // 1
        let mutableComposition: AVMutableComposition = AVMutableComposition()
        
        // 2
        let videoAsset1: AVURLAsset = AVURLAsset(URL: self.movieFile(url1!), options: nil)
        let videoAsset2: AVURLAsset = AVURLAsset(URL: self.movieFile(url2!), options: nil)
        let videoAsset3: AVURLAsset = AVURLAsset(URL: self.movieFile(url3!), options: nil)

        
        let videoAssetTrack1: AVAssetTrack = videoAsset1.tracksWithMediaType(AVMediaTypeVideo)[0]
        let audioAssetTrack1: AVAssetTrack = videoAsset1.tracksWithMediaType(AVMediaTypeAudio)[0]
        let videoAssetTrack2: AVAssetTrack = videoAsset2.tracksWithMediaType(AVMediaTypeVideo)[0]
        let audioAssetTrack2: AVAssetTrack = videoAsset2.tracksWithMediaType(AVMediaTypeAudio)[0]
        let videoAssetTrack3: AVAssetTrack = videoAsset3.tracksWithMediaType(AVMediaTypeVideo)[0]
        let audioAssetTrack3: AVAssetTrack = videoAsset3.tracksWithMediaType(AVMediaTypeAudio)[0]
        
        // 3
        let compositionVideoTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        // 4
        try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAssetTrack1.timeRange.duration), ofTrack: videoAssetTrack1, atTime: kCMTimeZero)
        try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAssetTrack1.timeRange.duration), ofTrack: audioAssetTrack1, atTime: kCMTimeZero)
        
        try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAssetTrack2.timeRange.duration), ofTrack: videoAssetTrack2, atTime: videoAssetTrack1.timeRange.duration)
        try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAssetTrack2.timeRange.duration), ofTrack: audioAssetTrack2, atTime: audioAssetTrack1.timeRange.duration)
        
        let timeDuration = CMTimeAdd(videoAssetTrack1.timeRange.duration, videoAssetTrack2.timeRange.duration)
        
        try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAssetTrack3.timeRange.duration), ofTrack: videoAssetTrack3, atTime: timeDuration)
        try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAssetTrack3.timeRange.duration), ofTrack: audioAssetTrack3, atTime: timeDuration)
        
        // 5
        let mutableVideoCompositionInstruction1 = AVMutableVideoCompositionInstruction()
        
        mutableVideoCompositionInstruction1.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack1.timeRange.duration)
        mutableVideoCompositionInstruction1.backgroundColor = UIColor.blackColor().CGColor
        
        let videoLayerInstruction1 = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        mutableVideoCompositionInstruction1.layerInstructions = [videoLayerInstruction1]
        
        let mutableVideoCompositionInstruction2 = AVMutableVideoCompositionInstruction()
        mutableVideoCompositionInstruction2.timeRange = CMTimeRangeMake(videoAssetTrack1.timeRange.duration, CMTimeAdd(videoAssetTrack1.timeRange.duration, videoAssetTrack2.timeRange.duration))
        mutableVideoCompositionInstruction2.backgroundColor = UIColor.blackColor().CGColor
        
        let videoLayerInstruction2 = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        mutableVideoCompositionInstruction2.layerInstructions = [videoLayerInstruction2]
        
        let mutableVideoCompositionInstruction3 = AVMutableVideoCompositionInstruction()
        mutableVideoCompositionInstruction3.timeRange = CMTimeRangeMake(videoAssetTrack2.timeRange.duration, CMTimeAdd(timeDuration, videoAssetTrack3.timeRange.duration))
        mutableVideoCompositionInstruction3.backgroundColor = UIColor.blackColor().CGColor
        
        let videoLayerInstruction3 = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        mutableVideoCompositionInstruction3.layerInstructions = [videoLayerInstruction3]
        
        // 6
        let mutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.instructions = [mutableVideoCompositionInstruction1, mutableVideoCompositionInstruction2, mutableVideoCompositionInstruction3]
        
        // 7
        let audioMixInputParameters = AVMutableAudioMixInputParameters(track: compositionAudioTrack)
        audioMixInputParameters.setVolumeRampFromStartVolume(1.0, toEndVolume: 1.0, timeRange: CMTimeRangeMake(kCMTimeZero, mutableComposition.duration))
        
        // 8
        let mutableAudioMix = AVMutableAudioMix()
        mutableAudioMix.inputParameters = [audioMixInputParameters]
        
        
        // 9
        let transform1: CGAffineTransform = videoAssetTrack1.preferredTransform
        let isVideoAssetPortrait: Bool = (transform1.a == 0 && transform1.d == 0 && (transform1.b == 1.0 || transform1.b == -1.0) && (transform1.c == 1.0 || transform1.c == -1.0))
        
        // 10
        var naturalSize1 = CGSizeZero
        var naturalSize2 = CGSizeZero
        var naturalSize3 = CGSizeZero
      
        /*
         if isVideoAssetPortrait {
         naturalSize1 = CGSizeMake(videoAssetTrack1.naturalSize.height, videoAssetTrack1.naturalSize.width)
         naturalSize2 = CGSizeMake(videoAssetTrack2.naturalSize.height, videoAssetTrack2.naturalSize.width)
         } else {
         */
        naturalSize1 = videoAssetTrack1.naturalSize
        naturalSize2 = videoAssetTrack2.naturalSize
        naturalSize3 = videoAssetTrack3.naturalSize
        //}
        
        let renderWidth = max(naturalSize1.width, naturalSize2.width, naturalSize3.width)
        let renderHeight = max(naturalSize1.height, naturalSize2.height, naturalSize3.height)
        
        // 11
        mutableVideoComposition.renderSize = CGSizeMake(renderWidth, renderHeight)
        /* 書き出す動画のフレームレート */
        mutableVideoComposition.frameDuration = CMTimeMake(1, 30)
        
        // 12
        let assetExportSession: AVAssetExportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPreset1280x720)!
        
        assetExportSession.videoComposition = mutableVideoComposition
        assetExportSession.audioMix = mutableAudioMix
        
        let composedMovieDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let composedMoviePath: String = "\(composedMovieDirectory)/\("test.mp4")"
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(composedMoviePath) {
            try! fileManager.removeItemAtPath(composedMoviePath)
        }
        
        // 13
        let composedMovieUrl = NSURL.fileURLWithPath(composedMoviePath)
        assetExportSession.outputFileType = AVFileTypeQuickTimeMovie
        assetExportSession.outputURL = composedMovieUrl
        assetExportSession.shouldOptimizeForNetworkUse = true
        
        assetExportSession.exportAsynchronouslyWithCompletionHandler {
            switch assetExportSession.status {
            case .Failed:
                print("生成失敗")
                break
            case .Cancelled:
                print("生成キャンセル")
                break
            default:
                print("生成完了")
                handler(url: composedMovieUrl)
                UISaveVideoAtPathToSavedPhotosAlbum(composedMoviePath, nil, nil, nil);
                
            }
        }
        
        
        
        
        
        
    }
    
    func movieFile(urlStr: String) -> NSURL {
        
        let url: NSURL = NSURL.fileURLWithPath(urlStr)
        return url
    }
    
}
