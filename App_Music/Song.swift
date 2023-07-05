import UIKit

final class Song {
    var songName:String
    var songImage:UIImage
    var songArtist:String
    var songFileName:String
    
    init(name: String, image: UIImage, artist: String, songFile: String) {
        self.songName     = name
        self.songImage    = image
        self.songArtist   = artist
        self.songFileName = songFile
    }
}
