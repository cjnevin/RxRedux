import UIKit

struct ImageState: StateType, Codable {
    private(set) var images: [ImageInfo] = []
    private(set) var errorMessage: String? = nil
    private(set) var selected: ImageInfo? = nil

    mutating func reduce(_ action: ActionType) {
        switch action {
        case ImageSearchAction.loadFailed(let error):
            errorMessage = error.localizedDescription
        case ImageSearchAction.loaded(let results):
            images = results
        case ImageSearchAction.loading:
            images = []
            errorMessage = nil
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
    case loaded([ImageInfo])
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
                store.dispatch(ImageSearchAction.loaded(images))
            case .failure(let error):
                store.dispatch(ImageSearchAction.loadFailed(error))
            }
        }
        return .loading
    }
}

struct ImageInfo: Codable {
    let author: String
    let description: String
    let title: String
    let link: String
    let imageUrl: String
    let tags: [String]
    let datePublished: Date
    let dateTaken: Date
}
