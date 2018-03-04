import UIKit

struct ImageState: StateType, Equatable, Codable {
    static func ==(lhs: ImageState, rhs: ImageState) -> Bool {
        let encoder = JSONEncoder()
        guard let left = try? encoder.encode(lhs), let right = try? encoder.encode(rhs) else {
            return false
        }
        return left.elementsEqual(right)
    }
    
    private(set) var isLoading: Bool = false
    private(set) var images: [ImageInfo] = []
    private(set) var errorMessage: String? = nil
    private(set) var selected: ImageInfo? = nil
    private(set) var query: String = ""

    mutating func reduce(_ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            isLoading = false
        case ImageSearchAction.loadFailed(let error):
            errorMessage = error.localizedDescription
            isLoading = false
        case ImageSearchAction.loaded(let searchTerm, let results):
            images = results
            query = searchTerm
            isLoading = false
        case ImageSearchAction.loading:
            images = []
            errorMessage = nil
            isLoading = true
        case ImageSearchAction.selected(let imageInfo):
            selected = imageInfo
        default:
            break
        }
    }
}

enum ImageSearchRoute: RouteAction {
    case showImage
}

enum ImageSearchAction: ActionType {
    case loading
    case loaded(String, [ImageInfo])
    case loadFailed(Error)
    case selected(ImageInfo)

    static func selectImage(_ imageInfo: ImageInfo) -> ActionType {
        store.dispatch(ImageSearchAction.selected(imageInfo))
        return ImageSearchRoute.showImage
    }

    static func search(for query: String) -> ImageSearchAction {
        ImageApi.search(for: query) { result in
            switch result {
            case .success(let images):
                store.dispatch(ImageSearchAction.loaded(query, images))
            case .failure(let error):
                store.dispatch(ImageSearchAction.loadFailed(error))
            }
        }
        return .loading
    }
}

struct ImageInfo: Codable, Equatable {
    static func ==(lhs: ImageInfo, rhs: ImageInfo) -> Bool {
        return lhs.author == rhs.author &&
            lhs.description == rhs.description &&
            lhs.title == rhs.title &&
            lhs.link == rhs.link &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.tags == rhs.tags &&
            lhs.datePublished == rhs.datePublished &&
            lhs.dateTaken == rhs.dateTaken
    }
    
    let author: String
    let description: String
    let title: String
    let link: String
    let imageUrl: String
    let tags: [String]
    let datePublished: Date
    let dateTaken: Date
}
