//import UIKit
//
//final class PhysicalCollectionView: UICollectionView {
//    
//    typealias DataSource = UICollectionViewDiffableDataSource<Int, RocketItem>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RocketItem>
//    
//    private var diffableDataSource: DataSource!
//    private var snapshot: Snapshot!
//    
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: .zero, collectionViewLayout: self.createLayout())
//        
//        configureDataSource()
//        applySnapshot()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func createLayout() -> UICollectionViewCompositionalLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
//                                              heightDimension: .absolute(100))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
//                                               heightDimension: .absolute(100))
//        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [item])
//
//        group.interItemSpacing = .fixed(10)
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = 10
//        section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//    
//    private func configureDataSource() {
//        
////        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier in
////            let cell = collectionView.dequeueConfiguredReusableCell(using: UICollectionViewCell.self, for: indexPath, item: <#T##Item?#>)
////            return cell
////        })
//    }
//    
//    private func applySnapshot() {
//        snapshot = Snapshot()
//        
//        snapshot.appendSections([0])
//        snapshot.appendItems([
//            .info(title: "asdasd", value: "sadsadas", uuid: UUID()),
//            .info(title: "asdasd", value: "sadsadas", uuid: UUID()),
//            .info(title: "asdasd", value: "sadsadas", uuid: UUID()),
//            .info(title: "asdasd", value: "sadsadas", uuid: UUID()),
//        ], toSection: 0)
//        
//        diffableDataSource.apply(snapshot, animatingDifferences: false)
//    }
//    
//}
