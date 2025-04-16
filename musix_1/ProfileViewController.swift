import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        usernameLabel.text = "packham0"
        [image1, image2, image3, image4].forEach {
            $0?.contentMode = .scaleAspectFill
            $0?.clipsToBounds = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        updateFavorites()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateFavorites() {
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: String]] ?? []
        let images = [image1, image2, image3, image4]
        let labels = [label1, label2, label3, label4]
        
        for i in 0..<4 {
            if i < favorites.count {
                let favorite = favorites[i]
                labels[i]?.text = "\(favorite["name"] ?? "") - \(favorite["artist"] ?? "")"
                images[i]?.setImage(from: favorite["imageURL"] ?? "", placeholder: UIImage(named: "defaultAlbum"))
            } else {
                labels[i]?.text = ""
                images[i]?.image = nil
            }
        }
    }
}
