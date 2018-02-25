# RxRedux
Custom implementation of Redux logic with Rx binding

![Redux](https://github.com/ChrisAU/RxRedux/blob/master/Redux.png "Redux")

# Action

`Actions` are payloads of information that send data from your application to your `Store`.

They are the only source of information for the `Store`.

You send them to the `Store` using `store.dispatch()`.

`Actions` must adhere to the `ActionType` protocol.

**Note:** In Swift, enums are perfectly suited for defining similar `Actions`.

```
enum FetchAction: ActionType {
    case started
    case success(Posts)
    case failure(Error)
}
```

Combined with generics you may be able to get away with just typealiases in many scenarios.

```
enum LoadAction<T>: ActionType {
    case started
    case success(T)
    case failure(Error)
}
typealias FetchAction = LoadAction<Posts>
```

# ActionCreator

`Action creators` are exactly that—functions that create `actions`. It's easy to conflate the terms “action” and “action creator,” so do your best to use the proper term.

Asynchronous `ActionCreator`'s can return an initial `Action` (such as loading) followed by other `Actions` as the asynchronous task progresses this can help you notify the user of a percentage of completion, a successful result, and an error.

Consider this _asynchronous_ action creator, it returns a result immediately, followed by another one after the API responds:

```
func fetchPosts(from url: URL) -> ActionType {
    api.fetch(url, method: .GET) { response, error in
        if let error = error {
            store.dispatch(FetchAction.failure(error))
        } else {
            store.dispatch(FetchAction.success(Posts.parse(response))
        }
    }
    return FetchAction.started
}
```

Alternatively, _synchronous_ action creators would likely trigger either action A or B depending on state:

```
func toggleSwitch(_ on: Bool) -> ActionType {
    return on ? SwitchAction.off : SwitchAction.on
}
```


# Reducer

`Reducers` are *pure* functions, they produce no side-effects and will always return the same output for a given input.

`Reducers` specify how the application's `State` changes in response to `Actions` sent to the `Store`.

`Reducers` can call other reducers in order to update different `State` objects.

**Remember:** `Actions` only describe the fact that something happened, but don't describe _how_ the application's `State` changes.

Each `State` object must define a mutating function as shown below:

```
struct CountState: StateType {
    var counter: Int = 0

    mutating func reduce(_ action: ActionType) {
        switch action {
        case CountAction.increment: counter += 1
        case CountAction.decrement: counter -= 1
        default: break
        }
    }
}
```

# Middleware

The `Middleware` provides a third-party extension point between dispatching an `Action`, and the moment it reaches the `Reducer`. People use Redux middleware for logging, crash reporting, talking to an asynchronous API, routing, and more.

**Note:** The `Middleware` provided in this implementation allows you to filter events so that they will not reach the `Reducer`. This might come in handy in some scenarios but should be used with care.

# State

The `State` is a representation of state for a given context. The context could be the application, a screen, a route, and many more.

The `State` object is immutable, it is a representation of the _current_ state.

In Redux there is only one application `State`. However, inside that object there might be other `SubState` objects that are updated by `Reducers`.

# Store

The `Store` is responsible for dispatching `Actions` to the `Middlewares` and main `Reducer` to mutate the `State`.

The `Store` holds onto the latest application `State`.

The `Store` provides methods of observing changes to `State` via `observe(keyPath)`, `observeOnMain(keyPath)`.

**Important:** you'll only have a single store in a Redux application.

# View

The only methods the `View` should call on the `Presenter` are the base methods present in `Presenter<T>`.

The `View` implements the contract that the `Presenter` defines.

The `View` is concerned with _how_ to present the data coming from the `Presenter`. This is where the `UIKit` imports are allowed and  also where we create our `NSAttributedString` objects.

The `View` notifies the `Presenter` of UI interaction via `Observables` (or `Action`'s - the RxSwift kind) defined in the `View`'s contract.

# Presenter<T>

The `Presenter` lays out a contract for the `View` to implement.

The `Presenter` dispatches `Actions` and receives `State` changes.

The `Presenter` is responsible for transforming the `State` into something consumable by the `View`.

The `Presenter` is responsible for _what_ the `View` will present, but not _how_ it will be displayed.

**Important:** The presenter does not import `UIKit`, it's concerned only with receiving and formatting the `State` for consumption by the `View`, these will usually be either `Model` objects or primitive types.

Observing changes using `KeyPath`:
```
store.observe(\.counter).subscribe { newCount in
    print("New count is:", newCount)
}
```

Sending actions to the store using `CocoaAction` from RxSwiftCommunity:
```
view.setIncrementAction(CocoaAction() { _ in
    .just(store.dispatch(CountAction.increment))
})
```
