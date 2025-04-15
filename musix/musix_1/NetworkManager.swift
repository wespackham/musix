import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received."
        case .networkError(let error): return error.localizedDescription
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "ac1252b16bf74e46c32ff303660ca7b3"
    private let baseUrl = "https://ws.audioscrobbler.com/2.0/"
    
    private init() {}
    
    func fetchRecentTracks(username: String, completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        let urlString = "\(baseUrl)?method=user.getRecentTracks&user=\(username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&api_key=\(apiKey)&limit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RecentTracksResponse.self, from: data)
                
                var albums: [Album] = []
                var seen: Set<String> = []
                for track in response.recenttracks.track {
                    let key = "\(track.albumName ?? "")-\(track.artistName)"
                    if let albumName = track.albumName, !albumName.isEmpty, !seen.contains(key) {
                        albums.append(Album(name: albumName, artistName: track.artistName, image: track.image))
                        seen.insert(key)
                    }
                }
                completion(.success(albums))
            } catch {
                completion(.failure(.networkError(error)))
            }
        }.resume()
    }
    
    func fetchAlbumInfo(albumName: String, artist: String, username: String, completion: @escaping (Result<AlbumDetails, NetworkError>) -> Void) {
        let urlString = "\(baseUrl)?method=album.getInfo&album=\(albumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&artist=\(artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&user=\(username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&api_key=\(apiKey)&format=json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AlbumInfoResponse.self, from: data)
                completion(.success(response.album))
            } catch {
                completion(.failure(.networkError(error)))
            }
        }.resume()
    }
}

struct RecentTracksResponse: Codable {
    let recenttracks: RecentTracks
}

struct RecentTracks: Codable {
    let track: [Track]
}

struct Track: Codable {
    let artist: Artist
    let album: AlbumInfo
    let image: [Image]?
    
    var artistName: String {
        artist.name
    }
    
    var albumName: String? {
        album.text
    }
}

struct AlbumInfo: Codable {
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
    }
}

struct AlbumInfoResponse: Codable {
    let album: AlbumDetails
}

struct AlbumDetails: Codable {
    let playcount: String
}

struct Album: Codable {
    let name: String
    let artistName: String
    let image: [Image]?
    
    var largeImageURL: String? {
        image?.first(where: { $0.size == "large" })?.text
    }
}

struct Artist: Codable {
    let name: String
}

struct Image: Codable {
    let size: String
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case size
        case text = "#text"
    }
}
