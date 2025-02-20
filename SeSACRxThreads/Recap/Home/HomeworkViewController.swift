//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

struct Person: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let email: String
    let profileImage: String
}

final class HomeworkViewController: BaseViewController {
    private let tableView = UITableView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let searchBar = UISearchBar()
    
    private let viewModel = HomeworkViewModel()
    private var disposeBag = DisposeBag()
    private let recent = BehaviorRelay(value: ["Jack"])
    private var items = BehaviorSubject(value: ["Test"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
     
    private func bind() {
        let input = HomeworkViewModel.Input(searchbuttonTap: <#T##ControlEvent<Void>#>, searchText: <#T##ControlProperty<String>#>)
        let output = viewModel.transform(input)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .map { "\($0)님"}
            .asDriver(onErrorJustReturn: "손님")
            .drive(with: self) { owner, value in
                var data = try? owner.items.value()
                data?.append(value)
                owner.items.onNext(data)
            }.disposed(by: disposeBag)
        
        recent
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: UserCollectionViewCell.id, cellType: UserCollectionViewCell.self)) { items, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
        
        items
            .asDriver(onErrorDriveWith: [])
            .drive(tableView.rx.items(cellIdentifier: PersonTableViewCell.id, cellType: PersonTableViewCell.self)) { row, element, cell in
                cell.usernameLabel.text = element
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(Int.self), tableView.rx.itemSelected)
            .asDriver(onErrorDriveWith: [])
            .map { $0.0 }
            .drive(with: self) { owner, text in
                print(text)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func setBinding() {
//        let input = HomeworkViewModel.Input(
//            selectedTrigger: tableView.rx.modelSelected(Person.self),
//            searchTrigger: PublishSubject()
//        )
//        let output = viewModel.transform(input)
//        
//        searchBar.rx.searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .bind(with: self) { owner, text in
//                input.searchTrigger.onNext(text)
//            }.disposed(by: disposeBag)
//        
//        output.userResult
//            .bind(to: tableView.rx.items(cellIdentifier: PersonTableViewCell.id, cellType: PersonTableViewCell.self)) { row, element, cell in
//                cell.configure(element)
//                
//                cell.detailButton.rx.tap
//                    .bind(with: self) { owner, _ in
//                        owner.navigationController?.pushViewController(DetailViewController(viewModel: DetailViewModel(title: element.name)), animated: true)
//                    }.disposed(by: cell.disposeBag)
//                
//            }.disposed(by: disposeBag)
//        
//        output.tapUserResult
//            .bind(to: collectionView.rx.items(cellIdentifier: UserCollectionViewCell.id, cellType: UserCollectionViewCell.self)) { items, element, cell in
//                cell.label.text = element.name
//            }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        configureTableView()
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        [tableView, collectionView, searchBar].forEach({ self.view.addSubview($0) })
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
 
extension HomeworkViewController {
    
    private func configureTableView() {
        tableView.rowHeight = 100
        tableView.backgroundColor = .systemGreen
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.id)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .lightGray
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.id)
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
}
