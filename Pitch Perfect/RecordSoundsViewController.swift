//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abdelaziz Elrashed on 5/30/15.
//  Copyright (c) 2015 Abdelaziz Elrashed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    let microphone_recording_image = UIImage(named: "microphone") as UIImage?
    let stop_recording_image = UIImage(named: "stop-recording") as UIImage?
    
    var clickCounter:Int = 0
    
    @IBOutlet weak var lbl_recording: UILabel!
    @IBOutlet weak var btn_recording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func AudioRecord(sender: UIButton) {
        // TODO: change Icon to stop icon
        self.clickCounter = self.clickCounter + 1
        println("Hello Recorder: \(self.clickCounter)")
        
        self.lbl_recording.hidden = !self.lbl_recording.hidden
        
        if self.lbl_recording.hidden{
            
            // Change Record Button image to stop image
            
            self.btn_recording.setImage(self.microphone_recording_image, forState: .Normal)
            
            // Stop Audio Recorder
            
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
            
        }else{
            
            // Change Record Button image to microphone image
            
            self.btn_recording.setImage(self.stop_recording_image, forState: .Normal)
            
            // Record Audio Section
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        println("# FINISH RECORDING #")
        
        if flag{
 
            // initiliaze recordedAudio and fill it with values
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Transition to next window
            self.performSegueWithIdentifier("stop_recording_segue", sender: recordedAudio)
            
        }else{
            
            println("# Error in Recording")
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stop_recording_segue"){
            let PlayAudioVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            PlayAudioVC.receivedAudio = data
        }
    }
}

