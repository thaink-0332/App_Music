import UIKit

final class LibraryVC: UIViewController {
    @IBOutlet private weak var songName: UILabel!
    @IBOutlet private weak var songArtist: UILabel!
    @IBOutlet private weak var songImage: UIImageView!
    private var songs: [Song] = []
    private var toSongVCIdentifier: String = Constants.toSongVCSegue.rawValue
    private var jpgRawValue: String = Constants.jpg.rawValue
    private var lastSongIndex: String = Constants.lastSongIndex.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSongLibrary()
    }
    
    private func createSongLibrary() {
        addNewSong(name: "Em của ngày hôm qua", imgName: "EmCuaNgayHomQuaImg",type:jpgRawValue, artist: "Sơn Tùng", songFile: "EmCuaNgayHomQua")
        addNewSong(name: "Waiting for you", imgName: "WaitingForYouImg",type:jpgRawValue, artist: "MONO", songFile: "WaitingForYou")
        addNewSong(name: "Nơi này có anh", imgName: "NoiNayCoAnhImg",type:jpgRawValue, artist: "Sơn Tùng", songFile: "NoiNayCoAnh")
    }
    
    private func addNewSong(name: String, imgName: String, type: String, artist: String, songFile: String) {
        if let imagePath = Bundle.main.path(forResource: imgName, ofType: type) {
            let image = UIImage(named: imagePath)
            songs.append(Song(name: name, image: image!, artist: artist, songFile: songFile))
        } else { return }
    }
}

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! CustomSongCell
        cell.setSongCell(name: songs[indexPath.row].songName, artist:songs[indexPath.row].songArtist, image: songs[indexPath.row].songImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: lastSongIndex)
        performSegue(withIdentifier: toSongVCIdentifier, sender: songs)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ViewController,
           let selectedArray = sender as? [Song] {
            destinationVC.setSongLibrary(array: selectedArray)
        }
    }
}
