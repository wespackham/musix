import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var recentAlbums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recent Albums"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        
        if let username = UserDefaults.standard.string(forKey: "lastfmUsername") {
            fetchRecentAlbums(for: username)
        } else {
            promptForUsername()
        }
    }
    
    private func promptForUsername() {
        let alert = UIAlertController(title: "Enter Username", message: "Last.fm username", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Username" }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let username = alert.textFields?.first?.text, !username.isEmpty {
                UserDefaults.standard.set(username, forKey: "lastfmUsername")
                self?.fetchRecentAlbums(for: username)
            } else {
                self?.showError("Username required.")
            }
        })
        present(alert, animated: true)
    }
    
    private func fetchRecentAlbums(for username: String) {
        NetworkManager.shared.fetchRecentTracks(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.recentAlbums = albums
                    self?.tableView.reloadData()
                case .failure:
                    self?.showError("Failed to load albums.")
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        let album = recentAlbums[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artistName
        if let imageURL = album.largeImageURL, !imageURL.isEmpty {
            cell.imageView?.setImage(from: imageURL, placeholder: UIImage(named: "defaultAlbum"))
        } else {
            cell.imageView?.image = UIImage(named: "defaultAlbum")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowAlbumDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbumDetail",
           let destination = segue.destination as? AlbumDetailViewController,
           let indexPath = sender as? IndexPath {
            destination.album = recentAlbums[indexPath.row]
        }
    }
}
