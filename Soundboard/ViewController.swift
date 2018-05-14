//
//  ViewController.swift
//  Soundboard
//
//  Created by Thomas Carlson on 13/5/18.
//  Copyright © 2018 SurfMachina. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var sounds : [Sound] = []
    var audioplayer : AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            sounds = try context.fetch(Sound.fetchRequest())
            tableview.reloadData()
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioplayer = try AVAudioPlayer(data: sound.audio! as Data)
            audioplayer?.play()
        } catch {}
        tableview.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            let sound = sounds[indexPath.row]
         
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(sound)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
            sounds = try context.fetch(Sound.fetchRequest())
            tableview.reloadData()
            } catch {}
            
        }
    }
    
}

