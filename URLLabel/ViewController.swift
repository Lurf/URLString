//
//  ViewController.swift
//  URLLabel
//
//  Created by Lurf on 2022/03/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textView.isSelectable = true
        textView.isEditable = false
        textView.delegate = self
    }
    
    private func generateURLString() {
        let urls = textView.text.extractURL()
        
        guard let baseText = textView.text else {
           return
        }
        let attributedString = NSMutableAttributedString(string: baseText)
        
        for url in urls {
            attributedString.addAttribute(
                .link,
                value: url.absoluteString,
                range: NSString(string: baseText).range(of: url.absoluteString)
            )
        }
        textView.attributedText = attributedString
    }
}

extension UIViewController: UITextViewDelegate {
    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        print(URL.absoluteString)
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
}

extension String {
    func extractURL() -> [URL] {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let links = detector.matches(in: self, range: NSMakeRange(0, self.count))
        return links.compactMap { $0.url }
    }
}
