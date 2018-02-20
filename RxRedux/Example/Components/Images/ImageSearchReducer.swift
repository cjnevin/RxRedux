import UIKit

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
        store.dispatch(NetworkAction.loading(true))
        ImageApi.search(for: query)
            .then { (images) in
                store.dispatch(ImageSearchAction.loaded(images))
            }
            .fail { (error) in
                store.dispatch(ImageSearchAction.loadFailed(error))
            }
            .always { _ in
                store.dispatch(NetworkAction.loading(false))
            }
        return .loading
    }
}

extension Reducers {
    static func reduce(_ state: ImageState, _ action: ActionType) -> ImageState {
        var state = state
        switch action {
        case ImageSearchAction.loadFailed(_):
            state.results = []
        case ImageSearchAction.loaded(let results):
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

struct ImageState {
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
