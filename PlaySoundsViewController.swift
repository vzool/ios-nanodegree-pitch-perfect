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
        
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        
        player.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Playing slow outlet action
    @IBAction func playSlowly(sender: UIButton) {
        playingWithRate(0.5)
    }
    
    // Playing fast outlet action
    @IBAction func playFast(sender: AnyObject) {
        playingWithRate(1.5)
    }
    
    // playing audio file with a specific speed rate
    func playingWithRate(rate: Float){
        
        stopAll()
        
        player.rate = rate
        player.play()
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        
        // It's safe to stop anything and then start over
        stopAll()
    }
    
    // To prevent overlap stop and reset player and audio engine
    func stopAll(){
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        player.currentTime = 0.0
    }
    
    @IBAction func ChipmunkPlay(sender: AnyObject) {
        
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func RobotSound(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    // Playing recorded audio with pitch degree
    func playAudioWithVariablePitch(pitch: Float){
        
        // It's safe to stop anything and then start over
        stopAll()
        
        // create a new Player Node and attached to AudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create a Pitch effect and attached to AudioEngine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect anything together
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // add audio file to schulder for future play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // play audio with above options
        audioPlayerNode.play()
    }

}
