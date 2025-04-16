import Foundation

enum NetworkError: String {
    case invalidURL = "Invalid URL"
    case noData = "No data"
    case parseFailed = "Failed to parse"
    case requestFailed = "Request failed"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://ws.audioscrobbler.com/2.0/"
    private let apiKey = "ac1252b16bf74e46c32ff303660ca7b3" // Replace with your Last.fm API key
    
    private init() {}
    
    func fetchRecentTracks(completion: @escaping ([[String: String]]?, String?) -> Void) {
        let urlString = "\(baseURL)?method=user.getrecenttracks&user=packham0&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL.rawValue)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, NetworkError.requestFailed.rawValue)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData.rawValue)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let recenttracks = json["recenttracks"] as? [String: Any],
                   let tracks = recenttracks["track"] as? [[String: Any]] {
                    let albums = tracks.compactMap { track -> [String: String]? in
                        guard let albumDict = track["album"] as? [String: String],
                              let albumName = albumDict["#text"],
                              !albumName.isEmpty,
                              let artistDict = track["artist"] as? [String: String],
                              let artistName = artistDict["#text"],
                              !artistName.isEmpty,
                              let images = track["image"] as? [[String: String]],
                              let imageURL = images.first(where: { $0["size"] == "large" })?["#text"] else {
                            return nil
                        }
                        return ["name": albumName, "artist": artistName, "imageURL": imageURL]
                    }
                    completion(albums, nil)
                } else {
                    completion(nil, NetworkError.parseFailed.rawValue)
                }
            } catch {
                completion(nil, NetworkError.parseFailed.rawValue)
            }
        }.resume()
    }
    
    func fetchWeeklyTracks(completion: @escaping ([[String: String]]?, String?) -> Void) {
        let urlString = "\(baseURL)?method=user.getweeklytrackchart&user=packham0&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL.rawValue)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, NetworkError.requestFailed.rawValue)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData.rawValue)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let chart = json["weeklytrackchart"] as? [String: Any],
                   let tracks = chart["track"] as? [[String: Any]] {
                    let results = tracks.compactMap { track -> [String: String]? in
                        guard let name = track["name"] as? String, !name.isEmpty,
                              let artistDict = track["artist"] as? [String: String],
                              let artist = artistDict["#text"], !artist.isEmpty,
                              let url = track["url"] as? String else {
                            return nil
                        }
                        return ["name": name, "artist": artist, "imageURL": ""]
                    }
                    completion(results, nil)
                } else {
                    completion(nil, NetworkError.parseFailed.rawValue)
                }
            } catch {
                completion(nil, NetworkError.parseFailed.rawValue)
            }
        }.resume()
    }
    
    func fetchWeeklyAlbums(completion: @escaping ([[String: String]]?, String?) -> Void) {
        let urlString = "\(baseURL)?method=user.getweeklyalbumchart&user=packham0&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL.rawValue)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, NetworkError.requestFailed.rawValue)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData.rawValue)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let chart = json["weeklyalbumchart"] as? [String: Any],
                   let albums = chart["album"] as? [[String: Any]] {
                    let results = albums.compactMap { album -> [String: String]? in
                        guard let name = album["name"] as? String, !name.isEmpty,
                              let artistDict = album["artist"] as? [String: String],
                              let artist = artistDict["#text"], !artist.isEmpty,
                              let url = album["url"] as? String else {
                            return nil
                        }
                        return ["name": name, "artist": artist, "imageURL": ""]
                    }
                    completion(results, nil)
                } else {
                    completion(nil, NetworkError.parseFailed.rawValue)
                }
            } catch {
                completion(nil, NetworkError.parseFailed.rawValue)
            }
        }.resume()
    }
    
    func fetchWeeklyArtists(completion: @escaping ([[String: String]]?, String?) -> Void) {
        let urlString = "\(baseURL)?method=user.getweeklyartistchart&user=packham0&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL.rawValue)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, NetworkError.requestFailed.rawValue)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData.rawValue)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let chart = json["weeklyartistchart"] as? [String: Any],
                   let artists = chart["artist"] as? [[String: Any]] {
                    let results = artists.compactMap { artist -> [String: String]? in
                        guard let name = artist["name"] as? String, !name.isEmpty,
                              let url = artist["url"] as? String else {
                            return nil
                        }
                        return ["name": name, "artist": "", "imageURL": ""]
                    }
                    completion(results, nil)
                } else {
                    completion(nil, NetworkError.parseFailed.rawValue)
                }
            } catch {
                completion(nil, NetworkError.parseFailed.rawValue)
            }
        }.resume()
    }
}
