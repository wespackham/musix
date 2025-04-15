import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playcountLabel: UILabel!
    
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        title = "Album Details"
        albumImageView.layer.cornerRadius = 10
        albumImageView.clipsToBounds = true
    }
    
    private func updateUI() {
        guard let album = album else {
            albumNameLabel.text = "Unknown Album"
            artistNameLabel.text = "Unknown Artist"
            playcountLabel.text = ""
            albumImageView.image = UIImage(named: "defaultAlbum")
            return
        }
        
        albumNameLabel.text = album.name
        artistNameLabel.text = album.artistName
        playcountLabel.text = "Fetching playcount..."
        
        if let imageURL = album.largeImageURL, !imageURL.isEmpty {
            albumImageView.setImage(from: imageURL, placeholder: UIImage(named: "defaultAlbum"))
        } else {
            albumImageView.image = UIImage(named: "defaultAlbum")
        }
        
        if let username = UserDefaults.standard.string(forKey: "lastfmUsername") {
            NetworkManager.shared.fetchAlbumInfo(albumName: album.name, artist: album.artistName, username: username) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let details):
                        self?.playcountLabel.text = "Played \(details.playcount) times"
                    case .failure:
                        self?.playcountLabel.text = "Playcount unavailable"
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let album = album else { return }
        
        var favorites = UserDefaults.standard.array(forKey: "favoriteAlbums") as? [[String: String]] ?? []
        let albumDict = ["name": album.name, "artist": album.artistName, "imageURL": album.largeImageURL ?? ""]
        
        if favorites.contains(where: { $0["name"] == album.name && $0["artist"] == album.artistName }) {
            favorites.removeAll { $0["name"] == album.name && $0["artist"] == album.artistName }
            sender.setTitle("Favorite", for: .normal)
        } else {
            favorites.append(albumDict)
            sender.setTitle("Unfavorite", for: .normal)
        }
        
        UserDefaults.standard.set(favorites, forKey: "favoriteAlbums")
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}

extension UIImageView {
    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
