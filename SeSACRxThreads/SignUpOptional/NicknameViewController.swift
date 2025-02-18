//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    // 이제 = x. next, complete, error
    private let nickname = BehaviorSubject(value: "고래밥") //Observable.just("고래밥") -> 보내는 역할만 가능하다!
    //랜덤배열
    private let recommandList = ["뽀로로", "상어", "악어", "고래", "칙촉", "추천"]
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nickname
            .subscribe(with: self) { owner, value in
                owner.nicknameTextField.text = value
            } onError: { owner, error in
                print("nickname onError")
            } onCompleted: { owner in
                print("nickname onCompleted")
            } onDisposed: { owner in
                print("nickname onDisposed")
            }.disposed(by: disposeBag)
        
        //map을 써도 되지만, 옵저버블 2개를 결합해볼 수도 있음
        nextButton
            .rx
            .tap
        //약한 참조를 통해 self에 대해 캡쳐 현상 방지.
            .withUnretained(self)
            .map { owner, _ in // 함수 매개변수 안에 함수가 있는 상태 map({}) -> map { }
                let random = self.recommandList.randomElement()!
                return random
            }
            .debug()
            .bind(to: nickname)
            .disposed(by: disposeBag)
//            .withLatestFrom(
//                Observable.just(recommandList.randomElement()!))
//            .flatMapLatest(Observable.just(recommandList.randomElement()!)))
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
        
        testPublishSubject()
//        testBehaviorSubject()
    }
    
    private func testBehaviorSubject() {
        let subject = BehaviorSubject(value: 0)
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onComplete")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(10)
        subject.onNext(22)
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(60)
    }
    
    private func testPublishSubject() {
        let subject = PublishSubject<Int>()
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onComplete")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(10)
        subject.onNext(22)
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(60)
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
