import RxSwift

protocol ActionType { }

struct Init: ActionType { }

var fire = PublishSubject<ActionType>()
