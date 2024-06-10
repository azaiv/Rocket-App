import UIKit

final class SettingsViewController: UIViewController {
    
    private lazy var closeButton = UIButton(type: .close)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = .init(customView: closeButton)
        self.closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    
    @objc func dismissController() {
        self.dismiss(animated: true)
    }
}
