//
//  SimpleCollectionViewController.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/26/25.
//

import UIKit
import SnapKit
/*
 Data
 -> DataSource (인덱스 기반) list[indexPath.row]
 -> DiffableDataSource (list[indexPath.item] 인덱스로 접근하지 않음, 데이터(모델)기반으로 조회를 한다.)
 
 Layout
 -> FlowLayout
 ->
 -> List Configuration
 
 Presentation
 -> CellForRowAt / dequeueReusableCell
 ->
 -> List Cell(View Configuration) dequeueConfiguredReusableCell
 */

final class SimpleCollectionViewController: UIViewController {
    struct Item: Hashable, Identifiable {
        let id = UUID()
        let name: String
        let price = 40000
        let count = 8
    }

    enum Section: CaseIterable {
        case main
        case sub
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var list = [
        Item(name: "Mackbook Pro M5"),
        Item(name: "키보드"),
        Item(name: "트랙패드"),
        Item(name: "금")
    ]
    
    //<섹션을 구분해 줄 데이터 타입, 셀에 들어가는 데이터 타입>
    //numberOfItemsInSection, cellForItemAt
//    private var dataSource: UICollectionViewDiffableDataSource<Int,Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        setSnapshot()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //Flow -> Compositinoal -> List Configuration
    //테이블뷰 시스템 기능 기능을 컬렉션뷰로도 만들수 있어
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped) //-> 테이블뷰 시스템 기능! 가능! 만들수 있어!
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemGreen
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        //collectionView.register 대신
//        var registration: UICollectionView.CellRegistration<UICollectionViewListCell,Product>!
        var registration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.textProperties.color = .brown
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            
            content.secondaryText = itemIdentifier.price.formatted()
            content.secondaryTextProperties.color = .blue
            
            content.image = UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
            
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backgroundConfig.backgroundColor = .yellow
//            backgroundConfig.cornerRadius = 40
            backgroundConfig.strokeColor = .systemRed
            backgroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item> (
            collectionView: collectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                //Q. list[indexPath.item] ??
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: itemIdentifier
                )
                
                return cell
        })
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases) //데이터 기반
        snapshot.appendItems([
            Item(name: "JackJack")
        ], toSection: .sub)
        
        snapshot.appendItems(list, toSection: .main)
        
        snapshot.appendItems([
            Item(name: "DenDen")
        ], toSection: .sub)
        
        dataSource?.apply(snapshot)
    }
}

extension SimpleCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource?.itemIdentifier(for: indexPath) ?? Item(name: "")
//        list.remove(at: indexPath.item)
//        let item = Item(name: "고래밥 \(Int.random(in: 1...100))")
//        list.insert(item, at: list.count)
        setSnapshot() //바뀌는 부분만 찰칵한다. 바뀌는 부분만 리소스를 쓰지 다른건 안한다고!
    }
    
}

//extension SimpleCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    //Q. 얘는 어디로 가는거지?
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
//    
//    /*
//     dequeueReusableCell
//     customCell + identifier + register
//     
//     dequeueConfigureReusableCell
//     systemCell + X + CellRegistration
//     */
//    //Identifier가 자연스레 빠져버림!!
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueConfiguredReusableCell(
//            using: registration,
//            for: indexPath,
//            item: list[indexPath.item]
//        )
//        
//        return cell
//    }
//    
//}
