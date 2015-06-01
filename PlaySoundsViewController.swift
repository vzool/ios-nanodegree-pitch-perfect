//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abdelaziz Elrashed on 5/31/15.
//  Copyright (c) 2015 Abdelaziz Elrashed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            
//            var URL = NSURL.fileURLWithPath(filePath)!
//            
//        }else{
//            println("File not found")
//        }
        
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        
        player.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        println("Slowly Mama")
        player.stop()
        player.rate = 0.5
        player.currentTime = 0.0
        player.play()
    }

    @IBAction func playFast(sender: AnyObject) {
        println("Quick Mama")
        player.stop()
        player.rate = 1.5
        player.currentTime = 0.0
        player.play()
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        println("Stop Mama")
        player.stop()
    }
    
    @IBAction func ChipmunkPlay(sender: AnyObject) {
        println("# ChipmunkPlay #")
        
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func RobotSound(sender: UIButton) {
        println("# Robot Sound #")
        playAudioWithVariablePitch(-1000)
    }
    
    //New Function
    func playAudioWithVariablePitch(pitch: Float){
        
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
