import Foundation
import When

enum ImageSearchRoute: RouteAction {
    case showImage
}

enum ImageSearchAction: ActionType {
    case loading
    case selected(ImageInfo)
    case results([ImageInfo])
    case failure(Error)
    
    static func selectImage(_ imageInfo: ImageInfo) -> ActionType {
        store.dispatch(ImageSearchAction.selected(imageInfo))
        return ImageSearchRoute.showImage
    }
    
    static func getSearchResults(_ query: String) -> ImageSearchAction {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ImageSearchAPI.search(for: query)
            .then { (images) in
                store.dispatch(ImageSearchAction.results(images))
            }
            .fail { (error) in
                store.dispatch(ImageSearchAction.failure(error))
            }
            .always { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        return .loading
    }
}

extension Reducers {
    static func reduce(_ state: ImageSearchState, _ action: ActionType) -> ImageSearchState {
        var state = state
        switch action {
        case ImageSearchAction.results(let results):
            state.results = results
        case ImageSearchAction.loading:
            state.results = []
        case ImageSearchAction.selected(let imageInfo):
            state.selected = imageInfo
        default:
            break
        }
        return state
    }
}

struct ImageSearchState {
    var results: [ImageInfo]
    var selected: ImageInfo?
}

struct ImageInfo {
    let author: String
    let description: String
    let title: String
    let link: String
    let imageUrl: String
    let tags: [String]
    let datePublished: Date
    let dateTaken: Date
}
