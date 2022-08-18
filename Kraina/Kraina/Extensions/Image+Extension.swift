
import Foundation
import UIKit

extension UIImageView {
    func load(url: String) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let urlUnwrapped = URL(string: url) else {return}
            if let data = try? Data(contentsOf: urlUnwrapped) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

