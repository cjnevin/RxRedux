import Foundation
import Action
import RxSwift

class ImagePresenter<T: ImageView>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        
        disposeOnViewDetach(store
            .observe(\.imageState.selected)
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { imageInfo in
                view.setTitle(ImageText.formatTitle(imageInfo.title))
                view.setImageInfo(imageInfo)
                view.setLinkAction(CocoaAction() {
                    .just(store.dispatch(ExternalRoute.openLink(imageInfo.link)))
                })
            }))
        
        disposeOnViewDetach(store
            .localizedObserve()
            .subscribe(onNext: { _ in
                view.setLinkTitle(ImageText.openLink)
            }))
    }
}

protocol ImageView: TitlableView {
    func setLinkTitle(_ title: String)
    func setLinkAction(_ action: CocoaAction)
    func setImageInfo(_ imageInfo: ImageInfo)
}

private enum ImageText {
    static var openLink: String { return "image.open.in.browser".localized() }
    
    static func formatTitle(_ title: String) -> String {
        var strippedTitle = title.trimmingCharacters(in: .whitespaces)
        if strippedTitle.count > 20 {
            strippedTitle = strippedTitle.prefix(20) + "…"
        } else if strippedTitle.isEmpty {
            strippedTitle = "Untitled"
        }
        return strippedTitle
    }
}

