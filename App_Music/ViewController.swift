import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    // Khai bao cac bien
    //
    @IBOutlet var play_button: UIButton!
    @IBOutlet var next_button: UIButton!
    @IBOutlet var previous_button: UIButton!
    @IBOutlet var song_name: UILabel!
    @IBOutlet var song_artist: UILabel!
    @IBOutlet var song_image: UIImageView!
    @IBOutlet var play_time: UISlider!
    var currentSongIndex: Int = 0
    var currentTimeLine: Float = 0.0
    var isPlaying : Bool = false
    var songLibrary:[Song] = []
    var timer: Timer?
    var player:AVAudioPlayer!
    var lastPlaybackTime: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Them cac ban nhac vao thu vien
        //
        if let imagePath = Bundle.main.path(forResource: "EmCuaNgayHomQuaImg", ofType: "jpg") {
            let image = UIImage(named: imagePath)
            songLibrary.append(Song(name: "Em của ngày hôm qua", image: image! , artist: "Sơn Tùng", songFile: "EmCuaNgayHomQua"))
        } else {
            return
        }
        
        if let imagePath = Bundle.main.path(forResource: "WaitingForYouImg", ofType: "jpg") {
            let image1 = UIImage(named: imagePath)
            songLibrary.append(Song(name: "Waiting for you", image: image1!, artist: "MONO", songFile: "WaitingForYou"))
        } else {
            return
        }
        
        if let imagePath = Bundle.main.path(forResource: "NoiNayCoAnhImg", ofType: "jpg") {
            let image2 = UIImage(named: imagePath)
            songLibrary.append(Song(name: "Nơi này có anh", image: image2! , artist: "Sơn Tùng", songFile: "NoiNayCoAnh"))
        } else {
            return
        }
        
        
        
        // Khoi tao ban nhac dau tien
        //
        do
        {   let lastSongIndex = UserDefaults.standard.object(forKey: "LastSongIndex") as? Int
            if lastSongIndex != nil{
                currentSongIndex = lastSongIndex!
            }
            else{
                currentSongIndex = 0
            }
            let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: "mp3")
            guard let urlString = urlString else{
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            song_name.text = songLibrary[currentSongIndex].songName
            song_artist.text = songLibrary[currentSongIndex].songArtist
            song_image.image = songLibrary[currentSongIndex].songImage
            play_button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            play_time.maximumValue = Float(player.duration)
            let lastPlaybackTime = UserDefaults.standard.object(forKey: "LastPlaybackTime") as? Double
            if lastPlaybackTime != nil{
                play_time.value = Float(lastPlaybackTime!)
            }
            else{
                play_time.value = 0
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            
            
        }
        catch{
            print("Something went wrong")
        }
        
        
        
    }
    
    
    //Ham play
    //
    @IBAction func tapPlayButton(){
        
        if isPlaying {
            isPlaying = false
            play_button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            currentTimeLine = Float(player.currentTime)
            UserDefaults.standard.set(currentTimeLine, forKey: "LastPlaybackTime")
            UserDefaults.standard.set(currentSongIndex, forKey: "LastSongIndex")
            print("Paused")
            player.pause()
            
            }
        else
            {   isPlaying = true;
                let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: "mp3")
                do{
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setActive(true)
                    guard let urlString = urlString else{
                        return
                    }
                    player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                    play_button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                    play_time.maximumValue = Float(player.duration)
                    let lastPlaybackTime = UserDefaults.standard.double(forKey: "LastPlaybackTime")
                    play_time.value = Float(lastPlaybackTime)
                    player.currentTime = lastPlaybackTime
                    player.play()
                    print("Set timer")
                
                }
                catch{
                    print("something went wrong")
                }
            }
    }
    
    //Ham tiep theo
    //
    @IBAction func tapNextButton(){
        if(currentSongIndex < songLibrary.count - 1)
            {   currentSongIndex += 1
                currentTimeLine = 0
            
            }
        
        else
            {   currentSongIndex = 0
                currentTimeLine = 0
            
            }
        
            //Khoi tao nhac moi va bat dau phat nhac
            //
            let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: "mp3")
            do{
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true)
                guard let urlString = urlString else{
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                song_name.text = songLibrary[currentSongIndex].songName
                song_artist.text = songLibrary[currentSongIndex].songArtist
                song_image.image = songLibrary[currentSongIndex].songImage
                play_button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                play_time.maximumValue = Float(player.duration)
                UIView.animate(withDuration: 0.3) {
                    self.play_time.setValue(0, animated: true)
                }
                UserDefaults.standard.set(currentSongIndex, forKey: "LastSongIndex")
                isPlaying = true
                player?.play()
                
            }
            catch{
                print("Something went wrong")
            }
            
        }
        
    //Ham quay lai
    //
    @IBAction func tapPreviousButton(){
        if(currentSongIndex > 0)
            {   currentSongIndex -= 1
                currentTimeLine = 0
            
            }
        else
            {   currentSongIndex = songLibrary.count - 1
                currentTimeLine = 0
            
            }
        
            //Khoi tao nhac moi va bat dau phat nhac
            //
            let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: "mp3")
            do{
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true)
                guard let urlString = urlString else{
                    return
                }
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                song_name.text = songLibrary[currentSongIndex].songName
                song_artist.text = songLibrary[currentSongIndex].songArtist
                song_image.image = songLibrary[currentSongIndex].songImage
                play_button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                play_time.maximumValue = Float(player.duration)
                UIView.animate(withDuration: 0.3) {
                    self.play_time.setValue(0, animated: true)
                }
                UserDefaults.standard.set(currentSongIndex, forKey: "LastSongIndex")
                isPlaying = true
                player?.play()
                
            }
            catch{
                print("Something went wrong")
            }
            
        }
    
    @IBAction func slideTimeLine(){
        isPlaying = true;
        currentTimeLine = play_time.value
        player.currentTime = Double(play_time.value)
        play_button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        player.play()
        
        
    }
    
    //Ham cap nhat
    //
    @objc func updateSlider() {
        if isPlaying{
            play_time.value = Float(player.currentTime)
            UserDefaults.standard.set(Float(player.currentTime), forKey: "LastPlaybackTime")
            }
        }
        
        
    

    
    
    class Song {
        var songName:String
        var songImage:UIImage
        var songArtist:String
        var songFileName:String
        
        init(name: String, image: UIImage, artist: String, songFile: String) {
            self.songName = name
            self.songImage = image
            self.songArtist = artist
            self.songFileName = songFile
            
        }
    }
    
    
}
