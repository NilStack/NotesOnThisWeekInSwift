
import UIKit
import PlaygroundSupport

var str = "Note on NatashaTheRobot's This Week in Swift February 6th 2017"

/*:
 ### [What's new in Swift 3.1](https://www.hackingwithswift.com/swift3-1)
 */

// Note: need Xcode 8.3 beta to run following codes

// 1. Concrete constrained extensions

// extends a protocol (Collection) only where it matches a constraint

#if swift(>=3.1)

extension Collection where Iterator.Element: Comparable {
    func lessThanFirstForCollection() -> [Iterator.Element] {
        guard let first = self.first else { return [] }
        return self.filter{ $0 < first }
    }
}

let items1 = [5, 6, 10, 4, 110, 3].lessThanFirstForCollection()
print(items1)

// That extends a concrete type (only Array) but still using a protocol for its constraint.

extension Array where Element: Comparable {
    func lessThanFirstForArray() -> [Element] {
        guard let first = self.first else { return [] }
        return self.filter{ $0 < first }
    }
}
let items2 = [5, 6, 10, 4, 110, 3].lessThanFirstForArray()
print(items2)

// New in Swift 3.1: That extends a concrete type (only Array) and uses a concrete constraint (only where the elements are Int).
extension Array where Element == Int {
    func lessThanFirstForInt() -> [Element] {
        guard let first = self.first else { return [] }
        return self.filter{ $0 < first }
    }
}

let items3 = [5, 6, 10, 4, 110, 3].lessThanFirstForInt()
print(items3)

// 2. Generic with nested types

// Nested types

struct Message {
    struct Attachment {
        var contents: String
    }
    
    var title: String
    var attachment: Attachment
}

// Generics

struct GenericMessage<T> {
    struct Attachment {
        var contents: String
    }
    
    var title: T
    var attachment: Attachment
}

// Generic nested type

struct GenericNestedMessage<T> {
    struct Attachment<T> {
        var contents: T
    }
    
    var title: T
    var attachment: Attachment<T>
}

// or

struct GenericNestedMessage2<T> {
    struct Attachment {
        var contents: T
    }
    
    var title: T
    var attachment: Attachment
}

// 3. Sequences get prefix(while:) and drop(while:) methods

let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]
    
let prefixed = names.prefix { $0.hasPrefix("Michael") }
print(prefixed)

let dropped = names.drop { $0.hasPrefix("Michael") }
print(dropped)

#endif

/*:
 ### [Non-contiguous raw value enumerations](http://ericasadun.com/2017/01/30/non-contiguous-raw-value-enumerations/)
 */

// create raw value enumerations that automatically incremented the value for each case

enum MyEnumeration1: Int {
    case one = 1, two, three, four
}

MyEnumeration1.three.rawValue // 3

// create raw value enumerations with hand-set values

enum MyEnumeration2: Int {
    case one = 1, three = 3, five = 5
}

// non-contiguous raw value enumeration

enum HTTPStatusCode: Int {
    // 100 Informational
    case continueCode = 100
    case switchingProtocols
    case processing
    // 200 Success
    case OK = 200
    case created
    case accepted
    case nonAuthoritativeInformation
}

HTTPStatusCode.accepted.rawValue // 202

/*:
 ### [Classes That Conform To Protocols](http://chris.eidhof.nl/post/classes-and-protocols/)
 */

// Swift solution for how to have a variable which stores a UIView that also conforms to a protocol like UIView<HeaderViewProtocol> in Objective-C

// workaround 1

protocol HeaderViewProtocol {
    func setTitle(_ string: String)
}

extension UIView: HeaderViewProtocol {
    func setTitle(_ string: String) {
        print("set title to: \(string)")
    }
    
}

struct AnyHeaderView {
    let view: UIView
    let headerView: HeaderViewProtocol
    init<T: UIView>(view: T) where T: HeaderViewProtocol {
        self.view = view
        self.headerView = view
    }
}

let myView = UIView()
let header = AnyHeaderView(view: myView)
header.headerView.setTitle("hi")

// workaround 2: get rid of the protocol

struct HeaderView {
    let view: UIView
    let setTitle: (String) -> ()
}

var label = UILabel()
let anotherHeader = HeaderView(view: label) { str in
    label.text = str
}
anotherHeader.setTitle("hello")

/*:
 ### [Prototyping Views in Playgrounds](http://binaryadventures.com/blog/snippet-of-the-week-prototyping-views-in-playgrounds/)
 */

// 1. import the module PlaygroundSupport at the top of your Playgrounds

// 2. select the Assistant editor in the Xcode view modes in the top-right corner of your window, or press CMD + ALT + Return.

// Let's create a view.
let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = UIColor.black

let redView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
redView.backgroundColor = UIColor.red
redView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(redView)

// use AutoLayout to change the view’s size.
redView.pinSize(CGSize(width: 200, height: 200))

// add some views to the composition and see your results directly
let blueView = UIView(frame: .zero)
blueView.translatesAutoresizingMaskIntoConstraints = false
blueView.backgroundColor = UIColor.blue
blueView.pinSize(CGSize(width: 100, height: 100))
view.addSubview(blueView)

let greenView = UIView(frame: .zero)
greenView.translatesAutoresizingMaskIntoConstraints = false
greenView.backgroundColor = UIColor.green
greenView.pinSize(CGSize(width: 75, height: 75))
view.addSubview(greenView)

// add and remove constraints as you please, while still quickly seeing the results!
view.pinSubviewToCenter(blueView)
view.pinAttribute(.leading, ofSubview: greenView, toAttribute: .trailing, ofView: blueView)
view.pinAttribute(.bottom, ofSubview: greenView, toAttribute: .bottom, ofView: view, offset: -50)

// Set the view to show in the Assistant Editor.
PlaygroundPage.current.liveView = view

/*:
   * Don’t forget to set xView.translatesAutoresizingMaskIntoConstraints = false. If not, your AutoLayout will fail.
   * try adding a view.layoutIfNeeded() just before adding it the PlaygroundSupport.current.liveView to force a layout refresh.
   * try cutting a significant portion of your layout code if it is is not reflected in the live view
   * Using a single Playgrounds file for prototyping can be annoying, so You can add files that are compiles by your playgrounds to the Playground’s sources or use Playgrounds in your project if you set up Frameworks properly.
 */

