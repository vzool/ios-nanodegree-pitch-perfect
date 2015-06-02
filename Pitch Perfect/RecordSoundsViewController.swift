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
    
    // Audio Recorder
    var audioRecorder:AVAudioRecorder!
    
    // Recorded Audio Model
    var recordedAudio:RecordedAudio!

    // Microphone image
    let microphone_recording_image = UIImage(named: "microphone") as UIImage?
    
    // Stop recording image
    let stop_recording_image = UIImage(named: "stop-recording") as UIImage?
    
    // recording label
    @IBOutlet weak var lbl_recording: UILabel!
    
    // microphone button and stop recording button
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
        
        // Swap state that helps to show
        lbl_recording.hidden = !lbl_recording.hidden
        
        if lbl_recording.hidden{
            
            // Change Record Button image to stop image
            
            btn_recording.setImage(microphone_recording_image, forState: .Normal)
            
            // Stop Audio Recorder
            
            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
            
        }else{
            
            // Change Record Button image to microphone image
            
            btn_recording.setImage(stop_recording_image, forState: .Normal)
            
            // Record Audio Section
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            
            // Get current Date and Time
            let currentDateTime = NSDate()
            
            // Create Date Formatter Instance
            let formatter = NSDateFormatter()
            
            // Set Date format
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            
            // Build DateTime String formation with Extension *.wav
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            
            // Construct Path Array
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)

            // Create Audio Record Session Instance
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            // Create Audio Recorder Instance with delegate reference to self pointer
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag{
 
            // initiliaze recordedAudio and fill with audio file values            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // Transition to next window
            performSegueWithIdentifier("stop_recording_segue", sender: recordedAudio)
            
        }else{
            
            println("# Error in Recording")
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Check if segue identifier is stop_recording_segue only
        if(segue.identifier == "stop_recording_segue"){
            // Create an Instance from PlaySoundsViewController
            let PlayAudioVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            // Transform data from sender(AnyObject) into RecordedAudio(NSObject)
            let data = sender as! RecordedAudio
            
            // Pass data to PlaySoundsViewController Before segue performed
            PlayAudioVC.receivedAudio = data
        }
    }
    
}

