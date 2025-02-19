//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    private var disposeBag = DisposeBag()
    
    lazy var items = BehaviorSubject(value: data)
    
    var data = [
        "First Item",
        "Second Item",
        "Third Item",
        "AAA",
        "C", "B", "AB", "BCA", "a","b","c","d","e","f"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func test() {
        let mentor = Observable.of("Hue", "Jack", "Bran", "Den")
        let age = Observable.of(10, 11, 12, 13)
        
        Observable.zip(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.appNameLabel.text = element
                cell.downloadButton.rx.tap
                    .withUnretained(self)
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.rowHeight.onNext(180)
        
        //서치바 + 엔터 + append
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, jack in
                print("Search Tap", jack)
                owner.data.insert(jack, at: 0)
                owner.items.onNext(owner.data)
                
            }
            .disposed(by: disposeBag)
        
        //실시간
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler())
            .distinctUntilChanged()
            .map { text in
                return self.data.filter { $0.contains(text) }
            }
            .bind(with: self) { owner, data in
                owner.items.onNext(data.isEmpty ? owner.data : data)
            }
            .disposed(by: disposeBag)
        
        
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
