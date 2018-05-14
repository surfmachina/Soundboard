//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Thomas Carlson on 13/5/18.
//  Copyright © 2018 SurfMachina. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var RecordStopButton: UIButton!
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var playbutton: UIButton!
    
    @IBOutlet weak var addbutton: UIButton!
    
    var audiorecorder : AVAudioRecorder? = nil
    var audioplayer : AVAudioPlayer? = nil
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuprecorder()
        playbutton.isEnabled = false
        addbutton.isEnabled = false
        
    }
    
    func setuprecorder() {
        // create audio session
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // create settings for recorder
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            
            // create URL for audio file
            let basepath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first!
            
            let pathcomponents = [basepath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathcomponents)!
            print(audioURL!)
            // create audio recorder object
            audiorecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audiorecorder!.prepareToRecord()
        } catch let error as NSError {
            print("#######################")
            print(error)
        }
        
    }
    
    @IBAction func recordtapped(_ sender: Any) {
        if audiorecorder!.isRecording   {
            audiorecorder?.stop()
            print("stopping recording")
            RecordStopButton.setTitle("Record", for: .normal)
            playbutton.isEnabled = true
            addbutton.isEnabled = true
        } else {
            // start the recording and change button title to stop
            audiorecorder?.record()
            print("Starting recording")
            RecordStopButton.setTitle("Stop", for: .normal)
            
        }
    }
    
    @IBAction func playtapped(_ sender: Any) {
        do {
            try audioplayer = AVAudioPlayer(contentsOf: audioURL!)
            audioplayer!.play()
        } catch {
            
        }
        
    }
    
    @IBAction func addtapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = textfield.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
}
