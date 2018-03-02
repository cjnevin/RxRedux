import RxSwift

protocol ActionType { }

struct Init: ActionType { }

let fire = PublishSubject<ActionType>()
