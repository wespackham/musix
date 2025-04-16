import UIKit

class AlbumDetailViewController: UIViewController {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var album: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album?["name"]
        nameLabel.text = album?["name"]
        artistLabel.text = album?["artist"]
        albumImage.setImage(from: album?["imageURL"] ?? "", placeholder: UIImage(named: "defaultAlbum"))
        updateFavoriteSwitch()
    }
    
    private func updateFavoriteSwitch() {
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: String]] ?? []
        favoriteSwitch.isOn = favorites.contains { $0["name"] == album?["name"] && $0["artist"] == album?["artist"] }
    }
    
    @IBAction func favoriteToggled(_ sender: UISwitch) {
        guard let album = album else { return }
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: String]] ?? []
        
        if sender.isOn {
            if favorites.count < 4 && !favorites.contains(where: { $0["name"] == album["name"] && $0["artist"] == album["artist"] }) {
                favorites.append(album)
            }
        } else {
            favorites.removeAll { $0["name"] == album["name"] && $0["artist"] == album["artist"] }
        }
        
        UserDefaults.standard.set(favorites, forKey: "favorites")
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}
