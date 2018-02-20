import Malibu
import When
import UIKit

class ImageApi {
    enum DownloadImageError: Swift.Error {
        case invalid
    }
    
    static func downloadImage(_ image: ImageInfo) -> Promise<UIImage> {
        let response = api.images.request(.downloadImage(path: image.imageUrl))
            .validate()
            .thenInBackground { (response) -> UIImage in
                guard let image = UIImage(data: response.data) else {
                    throw DownloadImageError.invalid
                }
                return image
        }
        return response
    }
    
    static func search(for query: String) -> Promise<[ImageInfo]> {
        let response = api.images.request(.search(query: query))
            .validate()
            .thenInBackground { (response) -> (ImageSearchResults) in
                try JSONDecoder().decode(ImageSearchResults.self, from: response.data)
            }
            .thenInBackground { (results) -> ([ImageInfo]) in
                results.items.map(ImageInfo.convert)
            }
        return response
    }
}

enum ImageRequest: RequestConvertible {
    case search(query: String)
    case downloadImage(path: String)
    
    static var baseUrl: URLStringConvertible? = nil
    static var headers: [String : String] = [:]
    
    var request: Request {
        switch self {
        case .search(query: let query):
            var parameters: [String: String] = [
                "format": "json",
                "nojsoncallback": "1",
                "tag_mode": "all"
            ]
            if !query.isEmpty {
                parameters["tags"] = query.replacingOccurrences(of: " ", with: ",")
            }
            return Request.get("https://api.flickr.com/services/feeds/photos_public.gne", parameters: parameters)
        case .downloadImage(path: let path):
            return Request.get(path)
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
