//
//  Seervice.swift
//  Practical Combine
//
//  Created by Oleksii Leshchenko on 23.09.2022.
//

import Foundation


struct Service {
    static let mockData = 1...10
    static func fetch(completion: @escaping (Result<String, Error>) -> Void) {
        mockData.forEach { (value) in
            let delay = DispatchTimeInterval.seconds(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == 8 {
                    completion(.failure(ServiceError.invalid))
                } else {
                    completion(.success("\(value)"))
                }
            
            }
        }
    }
    
    static func fetchModel(completion: @escaping (Result<TimeModel, Error>) -> Void) {
        mockData.forEach { (value) in
            let delay = DispatchTimeInterval.seconds(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion(.success(TimeModel(seconds: value)))
            
            }
        }
    }
}

struct ServiceError {
    static let invalid = NSError(domain: "Number 8 is invalid", code: 1, userInfo: nil)
}
