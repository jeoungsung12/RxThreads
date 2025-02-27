//
//  CompositionalViewController.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
/*
 1. 겹침, Hashable 하지 않을때
 */
final class CompositionalViewController: UIViewController {
    
    enum Section: CaseIterable {
        case first
        case second
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    var list = [1, 58, 2345, 898, 3, 7456, 78, 345]
    var list2 = [1, 2, 3, 4, 5, 6, 7, 8]
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureDatasource()
        configureSnapshot()
        multiUnicast()
    }
    
    private var disposeBag = DisposeBag()
    private func multiUnicast() {
//        let sampleInt = Observable<Int>.create { observer in
//            observer.onNext(Int.random(in: 1...100))
//            return Disposables.create()
//        }
        Observable.just([1,3,8])
        
        //구독시점과 상관없이 이벤트를 방출할수 있다.
        let sampleInt = PublishSubject<Int>()
        sampleInt.onNext(Int.random(in: 1...100))
        sampleInt
            .subscribe { value in
                print("1: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
                print("2: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
                print("3: \(value)")
            }
            .disposed(by: disposeBag)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,Int>?
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
//        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDatasource() {
        //cell register
        //cellForRowAt, cellForRowItems
        let cellRegistration = UICollectionView.CellRegistration<CompositionalCollectionViewCell,Int> {
            cell,
            indexPath,
            itemIdentifier in
            
            print("CellRegistration", indexPath)
            
//            var content = UIListContentConfiguration.subtitleCell()
//            content.text = itemIdentifier.formatted()
//            content.image = UIImage(systemName: "star")
//            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
                print("ReusableCell", indexPath)
                cell.label.text = "\(indexPath)"
                return cell
        })
    }
    
    private func configureSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section,Int>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(list, toSection: .second)
        snapShot.appendItems(list2, toSection: .first)
        dataSource?.apply(snapShot)
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, itemIdendifier in
            switch Section.allCases[index] {
            case .first:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 5,
                    leading: 5,
                    bottom: 5,
                    trailing: 5
                )
                
                let innerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                )
                let innerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: innerSize,
                    subitems: [item]
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [innerGroup]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 24
                return section
                
            case .second:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 5,
                    leading: 5,
                    bottom: 5,
                    trailing: 5
                )
                
                let innerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                )
                let innerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: innerSize,
                    subitems: [item]
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(200)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [innerGroup]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 24
                return section
            }
        }
        return layout
    }
    
    //외부 그룹, 내부 그룹 활용
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .fractionalHeight(1/3)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(
//            top: 5,
//            leading: 5,
//            bottom: 5,
//            trailing: 5
//        )
//        
//        let innerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1/3),
//            heightDimension: .fractionalHeight(1)
//        )
//        let innerGroup = NSCollectionLayoutGroup.vertical(
//            layoutSize: innerSize,
//            subitems: [item]
//        )
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(300),
//            heightDimension: .absolute(100)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [innerGroup]
//        )
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        section.interGroupSpacing = 24
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
    //수직
    //수평
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(100))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        section.interGroupSpacing = 24
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        configuration.backgroundColor = .purple
//        configuration.showsSeparators = true
////        configuration.leadingSwipeActionsConfigurationProvider
//        
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//        return layout
//    }
    
}
