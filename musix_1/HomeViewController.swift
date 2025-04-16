import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var albums: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        
        fetchAlbums()
    }
    
    private func fetchAlbums() {
        NetworkManager.shared.fetchRecentTracks { [weak self] albums, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    return
                }
                self?.albums = albums ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        let album = albums[indexPath.row]
        cell.textLabel?.text = album["name"] ?? "Unknown Album"
        cell.detailTextLabel?.text = album["artist"] ?? "Unknown Artist"
        cell.imageView?.setImage(from: album["imageURL"] ?? "", placeholder: UIImage(named: "defaultAlbum"))
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.accessoryType = .disclosureIndicator
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < albums.count {
            performSegue(withIdentifier: "ShowAlbumDetail", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbumDetail",
           let detailVC = segue.destination as? AlbumDetailViewController,
           let indexPath = sender as? IndexPath,
           indexPath.row < albums.count {
            detailVC.album = albums[indexPath.row]
        }
    }
}
