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

extension Reducers {
    static func reduce(_ state: ImageState, _ action: ActionType) -> ImageState {
        var state = state
        switch action {
        case ImageSearchAction.loadFailed(let error):
            state.images = []
            state.imagesError = error
        case ImageSearchAction.loaded(let results):
            state.images = results
            state.imagesError = nil
        case ImageSearchAction.loading:
            state.images = []
            state.imagesError = nil
        case ImageSearchAction.selected(let imageInfo):
            state.selected = imageInfo
        default:
            break
        }
        return state
    }
}

struct ImageState {
    var images: [ImageInfo]
    var imagesError: Error?
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
