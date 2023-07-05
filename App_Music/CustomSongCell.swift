import UIKit

final class CustomSongCell: UITableViewCell {
    @IBOutlet private weak var songName: UILabel!
    @IBOutlet private weak var songArtist: UILabel!
    @IBOutlet private weak var songImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setSongCell(name: String, artist: String, image: UIImage){
        self.songName.text   = name
        self.songArtist.text = artist
        self.songImage.image = image
    }
}
