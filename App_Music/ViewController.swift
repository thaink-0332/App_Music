//
//  ViewController.swift
//  App_Music
//
//  Created by Thai Nguyen Khac on 29/06/2023.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet var play_button: UIButton!
    @IBOutlet var next_button: UIButton!
    @IBOutlet var previous_button: UIButton!
    @IBOutlet var song_name: UILabel!
    @IBOutlet var song_artist: UILabel!
    @IBOutlet var song_image: UIImageView!
    @IBOutlet var play_time: UISlider!
    
    var player:AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapPlayButton(){
        if let player = player , player.isPlaying{
            
        }
        else
        {
            let urlString = Bundle.main.path(forResource: "EmCuaNgayHomQua", ofType: "mp3")
            do{
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true)
                guard let urlString = urlString else{
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                guard let player = player else{
                    return
                }
                
                player.play()
            }
            catch{
                print("something went wrong")
            }
        }
    }
    @IBAction func tapNextButton(){
        
    }
    @IBAction func tapPreviousButton(){
        
    }

}

