//
//  AgoraUploader.swift
//  Memberly
//
//  Created by SiviSoft on 19/03/21.
//
import Foundation
import CoreMedia
import ReplayKit
import AgoraRtcKit


class AgoraUploader {
    private static let videoDimension : CGSize = {
        let screenSize = UIScreen.main.currentMode!.size
        var boundingSize = CGSize(width: 480, height: 840)
        let mW = boundingSize.width / screenSize.width
        let mH = boundingSize.height / screenSize.height
        if( mH < mW ) {
            boundingSize.width = boundingSize.height / screenSize.height * screenSize.width
        }
        else if( mW < mH ) {
            boundingSize.height = boundingSize.width / screenSize.width * screenSize.height
        }
        return boundingSize
    }()
    
    
    private static let audioSampleRate: UInt = 8000
    private static let audioChannels: UInt = 2
    
    private static let defaults = UserDefaults(suiteName: "group.com.servicedx.sdxcontact")
    
    // indicate if stream has created
    private static var streamCreated = false
    private static var streamId: Int = 0
    
    private static let sharedAgoraEngine: AgoraRtcEngineKit = {
        
        let appId = defaults?.string(forKey: "AGORA_APP_ID")
        
        let kit = AgoraRtcEngineKit.sharedEngine(withAppId: appId ?? "", delegate: nil)
        
        
        //kit.setChannelProfile(.liveBroadcasting)
        //kit.setClientRole(.broadcaster)
        
        kit.setChannelProfile(.communication)
        
        kit.enableVideo()
        kit.setExternalVideoSource(true, useTexture: true, pushMode: true)
        let videoConfig = AgoraVideoEncoderConfiguration(size: videoDimension,
                                                                 frameRate: .fps24,
                                                                 bitrate: AgoraVideoBitrateStandard,
                                                                 orientationMode: .adaptative)
        kit.setVideoEncoderConfiguration(videoConfig)
        kit.setAudioProfile(.musicStandardStereo, scenario: .default)
        
        kit.enableExternalAudioSource(withSampleRate: audioSampleRate,
                                      channelsPerFrame: audioChannels)
        
        kit.muteAllRemoteVideoStreams(true)
        kit.muteAllRemoteAudioStreams(true)
        
        return kit
    }()
    
    static func startBroadcast() {
        print("startBroadcast called...")
        let agoraToken = defaults?.string(forKey: "AGORA_APP_TOKEN")
        let channelName = defaults?.string(forKey: "AGORA_CHANNEL_NAME")
        let userFullName = defaults?.string(forKey: "AGORA_USER_FULLNAME")
        let screenShareUid = UInt(defaults?.integer(forKey: "AGORA_SCREENSHARE_UID") ?? 0)
        
        sharedAgoraEngine.joinChannel(byToken: agoraToken ?? "", channelId: channelName ?? "", info: nil, uid: (screenShareUid != 0 ? screenShareUid : SCREEN_SHARE_UID), joinSuccess: {(channel, uid, elapsed) in
            debugPrint("joinSuccess --> \(channel) with uid \(uid) elapsed \(elapsed)ms")
            
            if !streamCreated {
                let result = AgoraUploader.sharedAgoraEngine.createDataStream(&streamId, reliable: true, ordered: true)
                if result == 0 {
                    streamCreated = true
                }
            }
            
            let jsonString = """
            {
                "event": "screen_share",
                "data": {
                    "status": "connected",
                    "userFullName": "\(userFullName ?? "")",
                    "uid": \(uid)
                }
            }
            """
            let result = sharedAgoraEngine.sendStreamMessage(streamId, data: Data(jsonString.utf8))
            if result != 0 {
                debugPrint("sendStreamMessage call failed: \(result), please check your params")
            } else {
                debugPrint("sendStreamMessage call success: \(result)")
            }
        })
        
    }
    
    static func sendVideoBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard let videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer)
             else {
            return
        }
        
        var rotation : Int32 = 0
        if let orientationAttachment = CMGetAttachment(sampleBuffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil) as? NSNumber {
            if let orientation = CGImagePropertyOrientation(rawValue: orientationAttachment.uint32Value) {
                switch orientation {
                case .up,    .upMirrored:    rotation = 0
                case .down,  .downMirrored:  rotation = 180
                case .left,  .leftMirrored:  rotation = 90
                case .right, .rightMirrored: rotation = 270
                default:   break
                }
            }
        }
        
        //let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let time = CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 1000)
        
        let frame = AgoraVideoFrame()
        frame.format = 12
        frame.time = time
        frame.textureBuf = videoFrame
        frame.rotation = rotation
        sharedAgoraEngine.pushExternalVideoFrame(frame)
    }
    
    static func sendAudioAppBuffer(_ sampleBuffer: CMSampleBuffer) {
        AgoraAudioTube.agoraKit(sharedAgoraEngine,
                                pushAudioCMSampleBuffer: sampleBuffer,
                                resampleRate: audioSampleRate,
                                type: .app)
    }
    
    static func sendAudioMicBuffer(_ sampleBuffer: CMSampleBuffer) {
        AgoraAudioTube.agoraKit(sharedAgoraEngine,
                                pushAudioCMSampleBuffer: sampleBuffer,
                                resampleRate: audioSampleRate,
                                type: .mic)
    }
    
    static func stopBroadcast() {
        print("leaving")
        sharedAgoraEngine.leaveChannel(nil)
    }
}
