//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    
    private var disposeBag = DisposeBag()
    private func bind() {
        //4자리 이상: 다음버튼 나타나고, 중복확인 버튼
        //4자리 미만: 다음버튼 X, 중복확인 버튼 click X
        let valid = emailTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 4 }
        
        valid
            .subscribe(with: self) { owner, value in
                owner.validationButton.isEnabled = value
                print("Valid Next")
            } onDisposed: { value in
                print("Valid Disposed")
            }
            .dispose()
        
//        valid
//            .bind(to: nextButton.rx.isHidden, validationButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
//        valid
//            .bind(with: self) { owner, value in
//                owner.nextButton.isHidden = value
//                owner.validationButton.isEnabled = value
//            }
//            .disposed(by: disposeBag)
        
        validationButton.rx.tap
            .bind(with: self) { owner, value in
                print("중복확인 버튼 클릭")
                owner.disposeBag = DisposeBag()
            }
            .disposed(by: disposeBag)
        
        emailPlaceholder
            .bind(to: emailTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    private func OperatorExample() {
//        let itemA = [3, 5, 23, 8, 10, 22]
//        
//        Observable
//            .repeatElement(itemA)
//            .take(10)
//            .subscribe(with: self) { owner, value in
//                print("JUST \(value)")
//            } onError: { owner, error in
//                print("JUST \(value)")
//            } onCompleted: { owner in
//                print("JUST \(value)")
//            } onDisposed: { owner in
//                print("JUST \(value)")
//            }
//            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
