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
    //Schedular == Main, Global
    let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
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
        //구독을 해제하는 시점을 수동으로 조절
        timer
            .subscribe(with: self) { owner, value in
                print("Timer", value) //next
            } onError: { owner, error in
                print("Timer onError")
            } onCompleted: { owner in
                print("Timer onCompleted")
            } onDisposed: { owner in
                print("Timer onDisposed")
            }.disposed(by: disposeBag)
        
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton //이벤트 전달. 옵저저블, next, ui
            .rx
            .tap
            .bind(with: self) { owner, _ in
                print(#function)
                //수동으로 개별적인 옵저버블을 관리
//                incrementValue.dispose()
                
                
                //password
//                let random = ["칙촉", "56", "ㅗㅓㅏ", "효ㅓㅏ"]
                //1. 등호가 왜 안되지?
                //2. 값을 왜 못바꿀까?
                //옵저버블은 이벤트만 전달함
                //이벤트는 받을 수 없음
                owner.password.onNext("456")
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    deinit {
        //self 캡쳐, 순환참조, 메모리 누수로 인해서 deinit 되지 않고 인스턴스가 계속 남아있음. Rx의 모든 코드가 살아있는 상태
        //Deinit이 될 때 구독이 정상적으로 해제된다. Dispose된 상태
        print("Password Deinit")
    }

}
