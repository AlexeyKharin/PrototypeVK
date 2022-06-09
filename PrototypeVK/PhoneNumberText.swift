
import Foundation
import Foundation
import UIKit

final class PhoneNumberText: UITextField {
    
    var onText: ((String) -> Void)?
    
    init(placeholder: String, onText: ((String) -> Void)?) {
        self.onText = onText
        super.init(frame: .zero)
        self.placeholder = placeholder
        toAutoLayout()
        addTarget(self, action: #selector(textPrinted), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6))
    }
    
    @objc private func textPrinted() {
        guard let text = text, !text.isEmpty else { return }
        onText?(text)
    }
}
