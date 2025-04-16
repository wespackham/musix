import UIKit

class AnalyticsViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    
    private var songs: [[String: String]] = []
    private var albums: [[String: String]] = []
    private var artists: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analytics"
        [collectionView1, collectionView2, collectionView3].forEach { cv in
            cv?.dataSource = self
            cv?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        }
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.shared.fetchWeeklyTracks { [weak self] data, _ in
            DispatchQueue.main.async {
                self?.songs = data ?? []
                self?.collectionView1.reloadData()
            }
        }
        NetworkManager.shared.fetchWeeklyAlbums { [weak self] data, _ in
            DispatchQueue.main.async {
                self?.albums = data ?? []
                self?.collectionView2.reloadData()
            }
        }
        NetworkManager.shared.fetchWeeklyArtists { [weak self] data, _ in
            DispatchQueue.main.async {
                self?.artists = data ?? []
                self?.collectionView3.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 { return songs.count }
        if collectionView == collectionView2 { return albums.count }
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 100))
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14) // Bold font
        label.numberOfLines = 3
        cell.contentView.addSubview(label)
        
        if collectionView == collectionView1 {
            let song = songs[indexPath.item]
            label.text = "\(song["name"] ?? "")\n\(song["artist"] ?? "")"
        } else if collectionView == collectionView2 {
            let album = albums[indexPath.item]
            label.text = "\(album["name"] ?? "")\n\(album["artist"] ?? "")"
        } else {
            let artist = artists[indexPath.item]
            label.text = artist["name"] ?? ""
        }
        
        return cell
    }
}
