import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

class ImageApi {
    enum DownloadImageError: Swift.Error {
        case invalid
    }
    
    enum SearchError: Swift.Error {
        case parseFailed
    }
    
    static func cancelImageDownload(at path: String) {
        api.networking.cancelGET(path)
    }
    
    static func downloadImage(at path: String, completion: @escaping (Result<UIImage>) -> ()) {
        api.networking.downloadImage(path) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.image))
            case .failure(let error):
                completion(.failure(error.error))
            }
        }
    }
    
    static func search(for query: String, completion: @escaping (Result<[ImageInfo]>) -> ()) {
        var parameters: [String: String] = [
            "format": "json",
            "nojsoncallback": "1",
            "tag_mode": "all"
        ]
        if !query.isEmpty {
            parameters["tags"] = query.replacingOccurrences(of: " ", with: ",")
        }
        api.networking.get("https://api.flickr.com/services/feeds/photos_public.gne", parameters: parameters) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.global(qos: .background).async {
                    do {
                        let results = try JSONDecoder().decode(ImageSearchResults.self, from: response.data)
                        let images = results.items.map(ImageInfo.convert)
                        DispatchQueue.main.async {
                            completion(.success(images))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(SearchError.parseFailed))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error.error))
                }
            }
        }
    }
}

extension ImageInfo {
    static func convert(from result: ImageSearchResults.Result) -> ImageInfo {
        let tags: [String] = result.tags
            .components(separatedBy: " ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let dateFormatter = ISO8601DateFormatter()
        let datePublished = dateFormatter.date(from: result.date_taken) ?? Date()
        let dateTaken = dateFormatter.date(from: result.published) ?? Date()
        
        let info = ImageInfo(
            author: result.author,
            description: result.description,
            title: result.title,
            link: result.link,
            imageUrl: result.media.m,
            tags: tags,
            datePublished: datePublished,
            dateTaken: dateTaken)
        
        return info
    }
}

struct ImageSearchResults: Decodable {
    let items: [Result]
    
    struct Result: Decodable {
        struct Media: Decodable {
            let m: String
        }
        
        let author: String
        let description: String
        let link: String
        let title: String
        let media: Media
        let published: String
        let tags: String
        let date_taken: String
    }
}
