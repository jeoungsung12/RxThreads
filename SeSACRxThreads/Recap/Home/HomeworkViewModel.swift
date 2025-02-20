//
//  HomeworkViewModel.swift
//  UIKit_Week9_A2
//
//  Created by 정성윤 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel: BaseViewModel {
    private(set) var sampleUsers: [Person] = [
        Person(name: "Steven", email: "steven.brown@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/1.jpg"),
        Person(name: "Mike", email: "mike.wilson@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/2.jpg"),
        Person(name: "Emma", email: "emma.taylor@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/1.jpg"),
        Person(name: "James", email: "james.anderson@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/3.jpg"),
        Person(name: "Lisa", email: "lisa.martin@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/2.jpg"),
        Person(name: "John", email: "john.davis@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/4.jpg"),
        Person(name: "Sarah", email: "sarah.white@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/3.jpg"),
        Person(name: "David", email: "david.miller@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/5.jpg"),
        Person(name: "Laura", email: "laura.jones@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/4.jpg"),
        Person(name: "Tom", email: "tom.wilson@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/6.jpg"),
        Person(name: "Amy", email: "amy.clark@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/5.jpg"),
        Person(name: "Paul", email: "paul.harris@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/7.jpg"),
        Person(name: "Karen", email: "karen.lewis@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/6.jpg"),
        Person(name: "Mark", email: "mark.lee@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/8.jpg"),
        Person(name: "Helen", email: "helen.young@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/7.jpg"),
        Person(name: "Ryan", email: "ryan.walker@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/9.jpg"),
        Person(name: "Lucy", email: "lucy.hall@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/8.jpg"),
        Person(name: "Eric", email: "eric.allen@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/10.jpg"),
        Person(name: "Kate", email: "kate.king@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/9.jpg"),
        Person(name: "Brian", email: "brian.scott@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/11.jpg"),
        Person(name: "Nancy", email: "nancy.green@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/10.jpg"),
        Person(name: "Chris", email: "chris.baker@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/12.jpg"),
        Person(name: "Diana", email: "diana.adams@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/11.jpg"),
        Person(name: "Kevin", email: "kevin.hill@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/13.jpg"),
        Person(name: "Julia", email: "julia.wright@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/12.jpg"),
        Person(name: "Gary", email: "gary.nelson@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/14.jpg"),
        Person(name: "Rachel", email: "rachel.carter@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/13.jpg"),
        Person(name: "Frank", email: "frank.mitchell@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/15.jpg"),
        Person(name: "Alice", email: "alice.perez@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/14.jpg"),
        Person(name: "Scott", email: "scott.roberts@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/16.jpg"),
        Person(name: "Maria", email: "maria.turner@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/15.jpg"),
        Person(name: "Peter", email: "peter.phillips@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/17.jpg"),
        Person(name: "Sandra", email: "sandra.campbell@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/16.jpg"),
        Person(name: "Jeff", email: "jeff.parker@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/18.jpg"),
        Person(name: "Paula", email: "paula.evans@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/17.jpg"),
        Person(name: "Doug", email: "doug.edwards@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/19.jpg"),
        Person(name: "Linda", email: "linda.collins@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/18.jpg"),
        Person(name: "Steve", email: "steve.stewart@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/20.jpg"),
        Person(name: "Carol", email: "carol.morris@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/19.jpg"),
        Person(name: "Dan", email: "dan.rogers@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/21.jpg"),
        Person(name: "Ruth", email: "ruth.reed@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/20.jpg"),
        Person(name: "Greg", email: "greg.cook@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/22.jpg"),
        Person(name: "Betty", email: "betty.morgan@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/21.jpg"),
        Person(name: "Alex", email: "alex.bell@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/23.jpg"),
        Person(name: "Janet", email: "janet.murphy@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/22.jpg"),
        Person(name: "Phil", email: "phil.bailey@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/24.jpg"),
        Person(name: "Judy", email: "judy.rivera@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/23.jpg"),
        Person(name: "Larry", email: "larry.cooper@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/25.jpg"),
        Person(name: "Rose", email: "rose.richardson@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/24.jpg"),
        Person(name: "Ralph", email: "ralph.cox@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/26.jpg"),
        Person(name: "Ann", email: "ann.howard@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/women/25.jpg")
    ]
    private var tapSampleData: [Person] = []
    private var disposeBag = DisposeBag()
    
    struct Input {
//        let selectedTrigger: ControlEvent<Person>
//        let searchTrigger: PublishSubject<String>
        let searchbuttonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    var recent = ["Jack"]
    var items = ["Test"]
    struct Output {
//        let userResult: BehaviorRelay<[Person]>
//        let tapUserResult: BehaviorRelay<[Person]>
        let items: BehaviorSubject<[String]>
        let recent: Driver<[String]>
    }
    
}

extension HomeworkViewModel {
    
    func transform(_ input: Input) -> Output {
        let recentList = BehaviorRelay(value: recent)
        let itemList = BehaviorSubject(value: items)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        input.searchbuttonTap
            .withLatestFrom(input.searchText)
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.items.append(text)
                
            })
            .disposed(by: disposeBag)
        
        
//        let tapUserResult: BehaviorRelay<[Person]> = BehaviorRelay(value: [])
//        
//        input.selectedTrigger
//            .bind(with: self) { owner, person in
//                owner.checkPerson(person)
//                tapUserResult.accept((owner.tapSampleData))
//            }.disposed(by: disposeBag)
//        
//        let sampleUsers = BehaviorRelay(value: sampleUsers)
//        input.searchTrigger
//            .bind(with: self) { owner, text in
//                let data = (!text.isEmpty) ? owner.sampleUsers.filter({ $0.name.contains(text) }) : owner.sampleUsers
//                sampleUsers.accept(data)
//            }.disposed(by: disposeBag)
//        
//        return Output(userResult: sampleUsers, tapUserResult: tapUserResult)
        return Output(items: itemList, recent: recentList)
    }
    
    private func checkPerson(_ person: Person) {
        var data = tapSampleData
        if tapSampleData.contains(person) {
            data.removeAll(where: { $0 == person })
        }
        data.insert(person, at: 0)
        tapSampleData = data
    }
}
