
import Foundation
protocol Coordinator: AnyObject {
    var coordinators: [Coordinator] { get set }
}
