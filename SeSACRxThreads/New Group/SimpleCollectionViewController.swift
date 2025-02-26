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
 -> Delegate, DataSource (인덱스 기반) list[indexPath.row]
 
 Layout
 -> FlowLayout
 ->
 -> List Configuration
 
 Presentation
 -> CellForRowAt / dequeueReusableCell
 ->
 -> List Cell(View Configuration)
 */

final class SimpleCollectionViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    //collectionView.register 대신
    private var registration: UICollectionView.CellRegistration<UICollectionViewListCell,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //Flow -> Compositinoal -> List Configuration
    //테이블뷰 시스템 기능 기능을 컬렉션뷰로도 만들수 있어
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped) //-> 테이블뷰 시스템 기능! 가능! 만들수 있어!
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureCell() {
        registration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            content.textProperties.color = .brown
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            
            content.secondaryText = "하하하하하"
            content.secondaryTextProperties.color = .blue
            
            content.image = UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
            
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backgroundConfig.backgroundColor = .yellow
            backgroundConfig.cornerRadius = 40
            backgroundConfig.strokeColor = .systemRed
            backgroundConfig.strokeWidth = 20
            
            cell.backgroundConfiguration = backgroundConfig
        }
    }
}

extension SimpleCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    /*
     dequeueReusableCell
     customCell + identifier + register
     
     dequeueConfigureReusableCell
     systemCell +  + CellRegistration
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: registration,
            for: indexPath,
            item: "테스트"
        )
        
        return cell
    }
    
}
