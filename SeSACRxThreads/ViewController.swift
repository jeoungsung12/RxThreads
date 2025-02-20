//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum JackError: Error {
    case incorrect
}

final class ViewController: UIViewController {
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    private var disposeBag = DisposeBag()
    
    private let publishSubject = PublishSubject<Int>()
    private let behaviorSubject = BehaviorSubject(value: 0)
    
    private let textFieldText = BehaviorRelay(value: "고래밥")
    private let textFieldPublish = PublishSubject<String>()
    
    private let quiz = Int.random(in: 1...10)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
//        bindTextField()
         bindCustomObservable()
        
        randomNumber()
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
    
    private func play(at randomNumber: Int) {
        randomQuiz(number: randomNumber)
            .subscribe(
                with: self) { owner, value in
                    print("next", value)
                } onError: { owner, error in
                    print("onError", error)
                } onCompleted: { owner in
                    print("onCompleted")
                } onDisposed: { owner in
                    print("onDisposed")
                }
                .disposed(by: disposeBag)
    }
    
    private func randomNumber() -> Observable<Int> {
        return Observable.create { observer in
            observer.onNext(Int.random(in: 1...10))
            return Disposables.create()
        }
    }
    
    private func randomQuiz(number: Int) -> Observable<Bool> {
        return Observable<Bool>.create { value in
            if number == self.quiz {
                value.onNext(true)
                value.onCompleted()
            } else {
                value.onError(JackError.incorrect)
            }
            return Disposables.create()
        }
    }
    
    private func bindCustomObservable() {
        nextButton.rx.tap
            .map { Int.random(in: 1...10) }
            .bind(with: self) { owner, value in
                print("value", value)
                owner.randomQuiz(number: value)
                    .bind(with: self) { owner, bool in
                        print(bool)
                    }.disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTextField() {
        textFieldText
            .subscribe(with: self) { owner, value in
                owner.nicknameTextField.text = value
                print("정상적으로 입력됨!")
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let value = owner.textFieldText.value
                print("behavior에 들어있는 데이터 가져오기")
            }
            .disposed(by: disposeBag)
    }
    
//    private func bindTextField() {
////        nicknameTextField.rx.text.orEmpty.changed //구독시 바로 한번 호출됨, focus시 다시호출
////            .subscribe(with: self) { owner, value in
////                print(#function, value)
////                print("실시간으로 텍스트필드 달라짐")
////            } onError: { owner, error in
////                print(#function, "nickname onError")
////            } onCompleted: { owner in
////                print(#function, "nickname onCompleted")
////            } onDisposed: { owner in
////                print(#function, "nickname onDisposed")
////            }.disposed(by: disposeBag)
//        
//        
//        
//        nextButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.nicknameTextField.rx.text.onNext("5")
//            }.disposed(by: disposeBag)
//        
////        publishSubject
////            .subscribe(with: self) { owner, value in
////                print(#function, value)
////                print("실시간으로 텍스트필드 달라짐")
////            } onError: { owner, error in
////                print(#function, "nickname onError")
////            } onCompleted: { owner in
////                print(#function, "nickname onCompleted")
////            } onDisposed: { owner in
////                print(#function, "nickname onDisposed")
////            }.disposed(by: disposeBag)
////        
////        behaviorSubject
////            .subscribe(with: self) { owner, value in //얘도 구독시 바로 한번 호출됨!
////                print(#function, value)
////                print("실시간으로 텍스트필드 달라짐")
////            } onError: { owner, error in
////                print(#function, "nickname onError")
////            } onCompleted: { owner in
////                print(#function, "nickname onCompleted")
////            } onDisposed: { owner in
////                print(#function, "nickname onDisposed")
////            }.disposed(by: disposeBag)
//        
//    }
    
//    private func bindButton() {
//        let button = nextButton.rx.tap
//            .debug("1")
//            .debug("2")
//            .debug("3")
//            .map { "안녕하세요 \(Int.random(in: 1...100))"}
////            .share() //하나의 subscribe를 공유하도록
////            .asDriver(onErrorJustReturn: "")
//            
//        button
////            .drive(navigationItem.rx.title)
//            .bind(to: navigationItem.rx.title)
//            .disposed(by: disposeBag)
//        button
////            .drive(nextButton.rx.title())
//            .bind(to: nextButton.rx.title())
//            .disposed(by: disposeBag)
//        button
////            .drive(nicknameTextField.rx.text)
//            .bind(to: nicknameTextField.rx.text)
//            .disposed(by: disposeBag)
//            
//    }
    
    //subscribe vs bind vs drive
//    private func bindButton() {
//        //버튼 > 서버통신(비동기) > UI업데이트(main)
//        nextButton.rx.tap
//            .map {
//                print(Thread.isMainThread)
//            }
//            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
//            .observe(on: MainScheduler.instance)
//            .map {
//                print(Thread.isMainThread)
//            }
//            .bind(with: self) { owner, _ in
//                print(#function, "클릭")
//                //메인!
//            }.disposed(by: disposeBag)
//        
//        
//        nextButton.rx.tap
//            .asDriver()
//            .drive(with: self) { owner, _ in
//                print("drive")
//            }.disposed(by: disposeBag)
//
//        
//
//    }
    
    private func configureLayout() {
        view.backgroundColor = .white
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

