import AVFoundation
import UIKit

enum Constants: String{
    case lastPlaybackTime = "LastPlaybackTime"
    case lastSongIndex    = "LastSongIndex"
    case mp3              = "mp3"
    case jpg              = "jpg"
}

final class ViewController: UIViewController {
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var songName: UILabel!
    @IBOutlet private weak var songArtist: UILabel!
    @IBOutlet private weak var songImage: UIImageView!
    @IBOutlet private weak var playTime: UISlider!
    private var currentSongIndex: Int = 0
    private var currentTimeLine: Float = 0.0
    private var isPlaying : Bool = false
    private var songLibrary:[Song] = []
    private var timer: Timer?
    private var player:AVAudioPlayer!
    private var lastPlaybackTime: Double?
    private var lastPlaybackTimeKey = Constants.lastPlaybackTime.rawValue
    private var lastSongIndexKey = Constants.lastSongIndex.rawValue
    private var mp3 = Constants.mp3.rawValue
    private var jpg = Constants.jpg.rawValue
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSongLibrary()
        initLastPlayedSong()
        
    }
    
    
    
    @IBAction private func tapPlayButton(){
        isPlaying ? pauseSong() : playSong()
    }
    
    
    @IBAction private func tapNextButton(){
        let numberOfSongs = songLibrary.count - 1
        currentSongIndex = currentSongIndex < numberOfSongs ? currentSongIndex + 1 : 0
        currentTimeLine = 0
        initNewSong()
        
    }
    
    
    @IBAction private func tapPreviousButton(){
        let numberOfSongs = songLibrary.count - 1
        currentSongIndex = currentSongIndex > 0 ? currentSongIndex - 1 : numberOfSongs
        currentTimeLine = 0
        initNewSong()
        
    }
    
    
    @IBAction private func slideTimeLine(){
        isPlaying = true;
        currentTimeLine = playTime.value
        player.currentTime = Double(playTime.value)
        playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        player.play()
        
        
    }
    
    
    private func playSong(){
        isPlaying = true;
        let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: mp3)
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true)
            guard let urlString = urlString else{
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            playTime.maximumValue = Float(player.duration)
            let lastPlaybackTime = UserDefaults.standard.double(forKey: lastPlaybackTimeKey)
            playTime.value = Float(lastPlaybackTime)
            player.currentTime = lastPlaybackTime
            player.play()
            
        }
        catch{
            
        }
    }
    
    private func pauseSong(){
        isPlaying = false
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        currentTimeLine = Float(player.currentTime)
        UserDefaults.standard.set(currentTimeLine, forKey: lastPlaybackTimeKey)
        UserDefaults.standard.set(currentSongIndex, forKey: lastSongIndexKey)
        player.pause()
    }
    
    @objc private func updateSlider() {
        if isPlaying{
            playTime.value = Float(player.currentTime)
            UserDefaults.standard.set(Float(player.currentTime), forKey: lastPlaybackTimeKey)
        }
    }
    
    private func initNewSong(){
        let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true)
            guard let urlString = urlString else{
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            songName.text = songLibrary[currentSongIndex].songName
            songArtist.text = songLibrary[currentSongIndex].songArtist
            songImage.image = songLibrary[currentSongIndex].songImage
            playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            playTime.maximumValue = Float(player.duration)
            UIView.animate(withDuration: 0.3) {
                self.playTime.setValue(0, animated: true)
            }
            UserDefaults.standard.set(currentSongIndex, forKey: lastSongIndexKey)
            isPlaying = true
            player?.play()
            
        }
        catch{
            
        }
    }
    
    private func initLastPlayedSong(){
        do { 
            let lastSongIndex = UserDefaults.standard.object(forKey: lastSongIndexKey) as? Int
            currentSongIndex = lastSongIndex != nil ? lastSongIndex! : 0
            let urlString = Bundle.main.path(forResource: songLibrary[currentSongIndex].songFileName, ofType: mp3)
            guard let urlString = urlString else{
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            songName.text = songLibrary[currentSongIndex].songName
            songArtist.text = songLibrary[currentSongIndex].songArtist
            songImage.image = songLibrary[currentSongIndex].songImage
            playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            playTime.maximumValue = Float(player.duration)
            let lastPlaybackTime = UserDefaults.standard.object(forKey: lastPlaybackTimeKey) as? Double
            playTime.value = lastPlaybackTime != nil ? Float(lastPlaybackTime!) : 0
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            
        }
        catch{
            
        }
    }
    
    private func addNewSong(name: String, imgName: String, type: String, artist: String, songFile: String){
        if let imagePath = Bundle.main.path(forResource: imgName, ofType: type) {
            let image = UIImage(named: imagePath)
            songLibrary.append(Song(name: name, image: image!, artist: artist, songFile: songFile))
        } else {
            return
        }
        
    }
    
    private func createSongLibrary(){
        addNewSong(name: "Em của ngày hôm qua", imgName: "EmCuaNgayHomQuaImg",type:jpg, artist: "Sơn Tùng", songFile: "EmCuaNgayHomQua")
        
        addNewSong(name: "Waiting for you", imgName: "WaitingForYouImg",type:jpg, artist: "MONO", songFile: "WaitingForYou")
        
        addNewSong(name: "Nơi này có anh", imgName: "NoiNayCoAnhImg",type:jpg, artist: "Sơn Tùng", songFile: "NoiNayCoAnh")
        
    }
    
}
