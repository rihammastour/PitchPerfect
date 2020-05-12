//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Riham Mastour on 15/09/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //dissable the stop recording button when loading!
        stopRecordingButton.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
    }


    @IBAction func recordingButton(_ sender: Any) {
        print("Recording button was pressed!")
        configureUI(isRecording : true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecordingButton(_ sender: Any) {
        print("Stop Recording button was pressed!")
        configureUI(isRecording : false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            // it sends the path to seconed ViewController!
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("finished recording!")
        }else{
             print("failed to record!")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            // seconed ViewController recives the path!
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    
    func configureUI(isRecording : Bool){
        if isRecording {
            recordingLable.text = "Recording in Progress!"
            stopRecordingButton.isEnabled = true
            recordingButton.isEnabled = false
        }else{
            recordingLable.text = "Tap to Record"
            stopRecordingButton.isEnabled = false
            recordingButton.isEnabled = true
        }
    }
    
    
}

