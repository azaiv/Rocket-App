import UIKit

class MainViewController: UIPageViewController {
    
    private let networkService = NetworkServie.shared
    
    private var pages: [RocketViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        dataSource = self
        delegate = self
        
        networkService.getRockets(completion: { result in
            
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    for rocket in rockets {
                        let vc = RocketViewController(rocket: rocket)
                        self.pages.append(vc)
                    }
                    
                    if let firstPage = self.pages.first {
                        self.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
                    }
                }
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        })

    }
    
    
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = pages.firstIndex(where: { $0 == firstViewController }) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? RocketViewController,
              let currentIndex = pages.firstIndex(of: contentVC),
              currentIndex > 0 else {
            return pages.last
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? RocketViewController,
              let currentIndex = pages.firstIndex(of: contentVC),
              currentIndex < pages.count - 1 else {
            return pages.first
        }
        return pages[currentIndex + 1]
    }
    
    
}
