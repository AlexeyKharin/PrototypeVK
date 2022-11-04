
import UIKit

class ViewVocntroller: UIViewController {
    var arrayTopics: [TopicResultElement] = []
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    
    }
}
