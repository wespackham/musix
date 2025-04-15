import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favoriteAlbumImageView1: UIImageView!
    @IBOutlet weak var favoriteAlbumImageView2: UIImageView!
    @IBOutlet weak var favoriteAlbumImageView3: UIImageView!
    @IBOutlet weak var favoriteAlbumImageView4: UIImageView!
    @IBOutlet weak var favoriteAlbumLabel1: UILabel!
    @IBOutlet weak var favoriteAlbumLabel2: UILabel!
    @IBOutlet weak var favoriteAlbumLabel3: UILabel!
    @IBOutlet weak var favoriteAlbumLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateFavorites()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        title = "Profile"
        usernameLabel.text = UserDefaults.standard.string(forKey: "lastfmUsername") ?? "No Username"
        
        [favoriteAlbumImageView1, favoriteAlbumImageView2, favoriteAlbumImageView3, favoriteAlbumImageView4].forEach {
            $0?.layer.cornerRadius = 5
            $0?.clipsToBounds = true
        }
    }
    
    @objc private func updateFavorites() {
        let favorites = UserDefaults.standard.array(forKey: "favoriteAlbums") as? [[String: String]] ?? []
        
        let imageViews = [favoriteAlbumImageView1, favoriteAlbumImageView2, favoriteAlbumImageView3, favoriteAlbumImageView4]
        let labels = [favoriteAlbumLabel1, favoriteAlbumLabel2, favoriteAlbumLabel3, favoriteAlbumLabel4]
        
        for (index, imageView) in imageViews.enumerated() {
            let label = labels[index]
            
            if index < favorites.count {
                let favorite = favorites[index]
                let name = favorite["name"] ?? "Unknown"
                let artist = favorite["artist"] ?? "Unknown"
                let imageURL = favorite["imageURL"] ?? ""
                
                label?.text = "\(name) by \(artist)"
                if !imageURL.isEmpty {
                    imageView?.setImage(from: imageURL, placeholder: UIImage(named: "defaultAlbum"))
                } else {
                    imageView?.image = UIImage(named: "defaultAlbum")
                }
            } else {
                label?.text = ""
                imageView?.image = nil
            }
        }
    }
}
