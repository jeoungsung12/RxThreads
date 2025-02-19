//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    private var disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextTap: ControlEvent<Void>
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension BirthdayViewModel {
    
    func transform(_ input: Input) -> Output {
        let year = BehaviorRelay(value: 2025)
        let month = BehaviorRelay(value: 2)
        let day = BehaviorRelay(value: 3)
        
        input.birthday
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.accept(component.year ?? 0)
                month.accept(component.month ?? 0)
                day.accept(component.day ?? 0)
            }
            .disposed(by: disposeBag)
        
        return Output(
            nextTap: input.nextTap,
            year: year,
            month: month,
            day: day
        )
    }
}
