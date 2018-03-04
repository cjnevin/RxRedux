import Foundation

fileprivate extension Style {
    static let all: [Style] = [
        Style(styleType: .blue),
        Style(styleType: .green)]
}

class Styler {
    func sideEffect(_ store: Store<AppState>, _ action: ActionType) {
        switch action {
        case AppLifecycleAction.ready:
            let style = store.state.styleState.current
            store.dispatch(StyleAction.set(style))
        case StyleAction.list(.loading):
            store.dispatch(StyleAction.list(.complete(Style.all)))
        case StyleAction.set(let style):
            style.apply()
        default:
            break
        }
    }
}
