//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/24/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
}

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callBoxOfficeWithSingle(date: String) -> Single<Movie> {
        
        return Single<Movie>.create { value in
            let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=&targetDt=\(date)"
            
            guard let url = URL(string: urlString) else {
                value(.failure(APIError.invalidURL))
                return Disposables.create {
                    print("Dispose 되었습니다. 끝!")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    value(.failure(APIError.unknownResponse))
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value(.failure(APIError.statusError))
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder()
                            .decode(Movie.self, from: data)
                        value(.failure(APIError.invalidURL))
//                        value(.success(result))
                    } catch {
                        print(error.localizedDescription)
                        value(.failure(APIError.invalidURL))
                    }
                } else {
                    value(.failure(APIError.invalidURL))
                }
            }.resume()
            
            return Disposables.create { print("Dispose 되었습니다. 끝!") }
        }
    }
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        return Observable<Movie>.create { observer in
            let urlString =  "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=&targetDt=\(date)"
            
            guard let url = URL(string: urlString) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create {
                    print("Dispose 되었습니다. 끝!")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder()
                            .decode(Movie.self, from: data)
                        observer.onError(APIError.statusError)
//                        observer.onNext(result)
//                        observer.onCompleted()
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(APIError.unknownResponse)
                    }
                } else {
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create { print("Dispose 되었습니다. 끝!") }
        }
    }
}
