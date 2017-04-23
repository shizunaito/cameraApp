//  Composition.swift

import UIKit
import AVFoundation
import MediaPlayer

class Composition: NSObject {
    class func run(_ urls : [String], handler: @escaping (_ url: URL) -> Void) {
        let mutableComposition: AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let compositionAudioTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime = kCMTimeZero
        
        for urlstr in urls {
            let url: URL = URL(fileURLWithPath: urlstr)
            let asset = AVURLAsset(url: url, options: nil)
            let tracks = asset.tracks(withMediaType: AVMediaTypeVideo)
            let audios = asset.tracks(withMediaType: AVMediaTypeAudio)
            let assetTrack:AVAssetTrack = tracks[0] as AVAssetTrack
            
            let transform: CGAffineTransform = assetTrack.preferredTransform
            let isVideoAssetPortrait: Bool = (transform.a == 0 && transform.d == 0 && (transform.b == 1.0 || transform.b == -1.0) && (transform.c == 1.0 || transform.c == -1.0))
            print(isVideoAssetPortrait)
            
            try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,asset.duration), of: assetTrack, at: insertTime)
            let assetTrackAudio:AVAssetTrack = audios[0] as AVAssetTrack
            try! compositionAudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,asset.duration), of: assetTrackAudio, at: insertTime)
            insertTime = CMTimeAdd(insertTime, asset.duration)
            
            
        }
        
        
        let assetExportSession: AVAssetExportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPreset1280x720)!
        
        let composedMovieDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let composedMoviePath: String = "\(composedMovieDirectory)/\("test.mp4")"
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: composedMoviePath) {
            try! fileManager.removeItem(atPath: composedMoviePath)
        }
        
        let composedMovieUrl = URL(fileURLWithPath: composedMoviePath)
        assetExportSession.outputFileType = AVFileTypeQuickTimeMovie
        assetExportSession.outputURL = composedMovieUrl
        assetExportSession.shouldOptimizeForNetworkUse = true
        
        assetExportSession.exportAsynchronously {
            switch assetExportSession.status {
            case .failed:
                print("生成失敗")
                break
            case .cancelled:
                print("生成キャンセル")
                break
            default:
                print("生成完了")
                handler(composedMovieUrl)
                UISaveVideoAtPathToSavedPhotosAlbum(composedMoviePath, nil, nil, nil);
                
            }
        }
    }
}
