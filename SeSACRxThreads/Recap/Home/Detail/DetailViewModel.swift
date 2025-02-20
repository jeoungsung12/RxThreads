//
//  DetailViewModel.swift
//  UIKit_Week9_A2
//
//  Created by 정성윤 on 2/19/25.
//

import Foundation

final class DetailViewModel: BaseViewModel {
    var title: String
    
    init(title: String) {
        self.title = title
        print(#function, self)
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension DetailViewModel {
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
