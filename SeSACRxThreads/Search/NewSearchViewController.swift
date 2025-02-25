//
//  NewSearchViewController.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class NewSearchViewController: BaseViewController {
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    private let viewModel = NewSearchViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchController()
        configure()
    }
    
    override func setBinding() {
        let input = NewSearchViewModel.Input(
            searchTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty
        )
        let output = viewModel.transform(input)
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.appNameLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .debug("Cell")
            .flatMapLatest { _ in
                (Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance))
                    .debug("timer")
            }
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
//            .withLatestFrom (Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance))
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .map { _ in
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            }
//            .subscribe(with: self) { owner, value in
//                value.subscribe(with: self) { owner, number in
//                    print(number)
//                }
//                .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        self.view.backgroundColor = .white
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
