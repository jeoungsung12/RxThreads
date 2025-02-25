//
//  MultiSectionViewController.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct Mentor {
    //섹션
    var name: String //섹션 타이틀 ex. Jack, Den, Bran.
    var items: [Item] //섹션 내에 셀에 들어갈 정보
}

struct Ment {
    let word: String
    let count = Int.random(in: 1...1000)
}

extension Mentor: SectionModelType {
    typealias Item = Ment
    
    init(original: Mentor, items: [Item]) {
        self = original
        self.items = items
    }
}

final class MultiSectionViewController: UIViewController {
    private let tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        let dataSource = RxTableViewSectionedReloadDataSource<Mentor> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
            cell.textLabel?.text = "\(item.word) - \(item.count)"
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        let mentor = [
            Mentor(name: "Jack", items: [
                Ment(word: "다시 해볼까요")
            ]),
            Mentor(name: "Den", items: [
                Ment(word: "다시 해볼까요")
            ]),
            Mentor(name: "Bran", items: [
                Ment(word: "다시 해볼까요")
            ])
        ]
        
        Observable.just(mentor)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SectionCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
