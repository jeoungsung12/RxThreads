//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
//    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PhoneViewController(), animated: true)
//    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    var password = BehaviorSubject(value: "1234")
    
    private func bind() {
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                print(#function)
                //password
//                let random = ["칙촉", "56", "ㅗㅓㅏ", "효ㅓㅏ"]
                //1. 등호가 왜 안되지?
                //2. 값을 왜 못바꿀까?
                //옵저버블은 이벤트만 전달함
                //이벤트는 받을 수 없음
                owner.password.onNext("456")
            }
            .disposed(by: disposeBag)
    }

}
