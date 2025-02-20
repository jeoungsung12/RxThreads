//
//  BaseViewModel.swift
//  UIKit_Week9_A2
//
//  Created by 정성윤 on 2/19/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
