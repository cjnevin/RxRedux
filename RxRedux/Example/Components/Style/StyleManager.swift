import Foundation

extension Style {
    static let all: [Style] = [Style(styleType: .blue),
                               Style(styleType: .green)]
}

struct StyleManager {
    func sideEffect(_ state: AppState, _ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            let style = state.styleState.current
            fire.onNext(StyleAction.set(style))
        case StyleAction.list(.loading):
            fire.onNext(StyleAction.list(.complete(Style.all)))
        case StyleAction.set(let style):
            DispatchQueue.main.async {
                style.apply()
            }
        default:
            break
        }
    }
}
