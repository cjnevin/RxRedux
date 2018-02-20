import Malibu
import When
import UIKit

class ImageSearchAPI {
    static func search(for query: String) -> Promise<[ImageInfo]> {
        let path: String = "https://api.flickr.com/services/feeds/photos_public.gne"
        var parameters: [String: String] = [
            "format": "json",
            "nojsoncallback": "1",
            "tag_mode": "all"
        ]
        if !query.isEmpty {
            parameters["tags"] = query.replacingOccurrences(of: " ", with: ",")
        }
        let request = Request
            .get(path, parameters: parameters,
                 storePolicy: .offline,
                 cachePolicy: .returnCacheDataElseLoad)
        let response = Malibu.request(request)
            .validate()
            .thenInBackground { (response) -> (ImageSearchResults) in
                try JSONDecoder().decode(ImageSearchResults.self, from: response.data)
            }
            .thenInBackground { (results) -> ([ImageInfo]) in
                results.items.map(ImageInfo.convert)
            }
        return response
    }
    
    enum DownloadImageError: Swift.Error {
        case invalid
    }
    
    static func downloadImage(_ image: ImageInfo) -> Promise<UIImage> {
        let request = Request.get(image.imageUrl)
        let promise = Malibu.request(request)
            .validate()
            .thenInBackground { (response) -> UIImage in
                guard let image = UIImage(data: response.data) else {
                    throw DownloadImageError.invalid
                }
                return image
            }
        
        return promise
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
