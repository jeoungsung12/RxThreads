//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let emailText = Observable.just("a@a.com")
    let backgroundColor = Observable.just(UIColor.lightGray)
    let signUpTitle = Observable.just("회원이 아직 아니십니까?")
    let signUpTitleColor = Observable.just(UIColor.black)
    private var disposeBag = DisposeBag()
    private func bindBackgroundColor() {
        //이벤트를 받지 못하는 bind로, next만 동작되는 기능이라면 bind로 구현
        backgroundColor
            .bind(with: self, onNext: { owner, value in
                owner.view.backgroundColor = value
            })
            .disposed(by: disposeBag)
        
        backgroundColor
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        backgroundColor
            .subscribe(with: self) { owner, value in
                owner.view.backgroundColor = value
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        //async, stream
        signUpButton
            .rx
            .tap //여기까지가 Observable
            .subscribe { [weak self] _ in
                self?.navigationController?.pushViewController(SignUpViewController(), animated: true)
                print("button tap onNext")
            } onError: { error in
                print("button tap onError: \(error)")
            } onCompleted: {
                print("button tap onCompleted")
            } onDisposed: {
                print("button tap onDisposed")
            }
            .disposed(by: disposeBag)
            
        emailText
            .subscribe { [weak self] value in
                self?.emailTextField.text = value
                print("emailText tap onNext")
            } onError: { error in
                print("emilText onError: \(error)")
            } onCompleted: {
                print("emilText onCompleted")
            } onDisposed: {
                print("emilText onDisposed")
            }
            .disposed(by: disposeBag)

    }
    
    func configure() {
        
        signUpTitle
            .bind(to: signUpButton.rx.title())
            .disposed(by: disposeBag)
        
        signUpTitleColor
            .bind(with: self) { owner, color in
                owner.signUpButton.setTitleColor(color, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
