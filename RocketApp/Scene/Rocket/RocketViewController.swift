import UIKit

final class RocketViewController: UIViewController {
    
    // - MARK: Singleton
    private let networkService = NetworkServie.shared
    
    
    // - MARK: View
    private lazy var rocketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    private lazy var scrollView: UIScrollView =  {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    private var rocketView: RocketInfoView!
    

    // - MARK: Constraint
    private var rocketImageHeightConstraint = NSLayoutConstraint()
    private var tableViewHeightConstraint = NSLayoutConstraint()

    
    // - MARK: Values
    private var rocket: RocketModel!
    
    
    
    // - MARK: Lifecycle
    init(rocket: RocketModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.rocket = rocket
        rocketView = RocketInfoView(rocket: rocket)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        networkService.fetchImage(from: rocket.flickrImages.randomElement(),
                                  completion: { image in
            DispatchQueue.main.async {
                UIView.transition(
                    with: self.rocketImage,
                    duration: 0.4,
                    options: .transitionCrossDissolve,
                    animations: {  self.rocketImage.image = image },
                    completion: nil)
            }
        })
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let contnetHeight = rocketView.tableView.contentSize.height + (view.frame.height / 3)

        if scrollView.contentSize.height != contnetHeight {
            tableViewHeightConstraint.constant = rocketView.tableView.contentSize.height
            scrollView.contentSize = .init(width: view.frame.width, height: contnetHeight)
        }

    }
    
    
    
    // - MARK: Setup
    private func setupView() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(rocketImage)
        rocketImage.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(rocketView)
        rocketView.translatesAutoresizingMaskIntoConstraints = false
        
        rocketImageHeightConstraint = rocketImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        
        rocketImageHeightConstraint.isActive = true
        
        tableViewHeightConstraint = rocketView.heightAnchor.constraint(equalToConstant: view.frame.height)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rocketImage.topAnchor.constraint(equalTo: view.topAnchor),
            rocketImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rocketImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            rocketView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: view.frame.height / 3),
            rocketView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rocketView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        rocketView.settingsButton.addTarget(self, action: #selector(openSettingsController), for: .touchUpInside)
        
    }


    // - MARK: Action
    @objc func openLaunchesController() {
        let vc =  UINavigationController(rootViewController: LaunchesViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func openSettingsController() {
        let vc =  UINavigationController(rootViewController: SettingsViewController())
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
}


// - MARK: UIScrollViewDelegate
extension RocketViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = (view.frame.height / 2) - scrollView.contentOffset.y
        rocketImageHeightConstraint.constant = height
        
        let topInset = max(height, height) - view.safeAreaInsets.top
        scrollView.verticalScrollIndicatorInsets = .init(top: topInset, left: 0, bottom: 0, right: 0)

    }
    
}


