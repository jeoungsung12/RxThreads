//
//  DetailViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    
    let nextButton = PointButton(title: "다음")
    private var disposeBag = DisposeBag()
    var viewModel: DetailViewModel
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        let tap = nextButton.rx.tap
            .map { Int.random(in: 1...100) }
            .share(replay: 1)
        
        tap
            .bind(with: self) { owner, value in
                print("1번 - \(value)")
            }
            .disposed(by: disposeBag)
        tap
            .bind(with: self) { owner, value in
                print("2번 - \(value)")
            }
            .disposed(by: disposeBag)
        tap
            .bind(with: self) { owner, value in
                print("3번 - \(value)")
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .lightGray
        navigationItem.title = viewModel.title
    }
    
    override func configureHierarchy() {
        view.addSubview(nextButton)
    }
    
    override func configureLayout() {
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalTo(view)
        }
    }
    
}
