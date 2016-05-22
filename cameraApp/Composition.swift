//
//  Composition.swift
//  cameraApp
//
//  Created by 伊藤静那(Ito Shizuna) on 2016/05/22.
//  Copyright © 2016年 knj0302. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Composition: NSObject {
    class func run(urls : [String], handler: (url: NSURL) -> Void) {
        let mutableComposition: AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let compositionAudioTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime = kCMTimeZero
        for urlstr in urls {
            let url: NSURL = NSURL.fileURLWithPath(urlstr)
            let asset = AVURLAsset(URL: url, options: nil)
            let tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
            let audios = asset.tracksWithMediaType(AVMediaTypeAudio)
            let assetTrack:AVAssetTrack = tracks[0] as AVAssetTrack
            try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,asset.duration), ofTrack: assetTrack, atTime: insertTime)
            let assetTrackAudio:AVAssetTrack = audios[0] as AVAssetTrack
            try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,asset.duration), ofTrack: assetTrackAudio, atTime: insertTime)
            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        let assetExportSession: AVAssetExportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPreset1280x720)!
        
        let composedMovieDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let composedMoviePath: String = "\(composedMovieDirectory)/\("test.mp4")"
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(composedMoviePath) {
            try! fileManager.removeItemAtPath(composedMoviePath)
        }
        
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
}