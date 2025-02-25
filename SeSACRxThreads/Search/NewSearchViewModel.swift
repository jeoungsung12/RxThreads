//
//  NewSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NewSearchViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    struct Input {
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let list: Driver<[DailyBoxOfficeList]>
    }
    
}

extension NewSearchViewModel {
    //map, withLatestFrom, flatMap, flatMapLatest
    func transform(_ input: Input) -> Output {
        let resultList: PublishSubject<[DailyBoxOfficeList]> = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let text = Int($0) else {
                    return 20250223
                }
                return text
            }
            .map { return "\($0)"}
            .flatMapLatest { value in
                NetworkManager.shared.callBoxOfficeWithSingle2(date: value)
//                return NetworkManager.shared.callBoxOffice(date: value)
//                    .debug("Movie")
//                    .catch { error in
//                        switch error as! APIError {
//                        case .invalidURL:
//                            
//                        case .statusError:
//                            
//                        case .unknownResponse:
//                            
//                        default:
//
//                        }
//                        print("Movie Error", error)
//                        return Observable<Movie>.just(Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [])))
//                    }
//                NetworkManager.shared.callBoxOfficeWithSingle(date: value)
//                    .catch { error in
//                        return Single<Movie>.just(Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [])))
//                    }
//                    .debug("Single Movie")
            }
//            .flatMap { result in
//                switch result {
//                case let .success(data):
//                    
//                case let .failure(error):
//                    
//                }
//            }
//            .catch { error in
//                return Observable<Movie>.just(Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [])))
//            }
            .debug("Tap")
            .subscribe(with: self) { owner, result in
                print("tap next")
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    print(error)
                }
//                resultList.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("ondisposed")
            }
            .disposed(by: disposeBag)
        
        return Output(
            list: resultList.asDriver(onErrorJustReturn: [])
        )
    }
    
}
