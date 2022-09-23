//
//  ContentViewModel.swift
//  Practical Combine
//
//  Created by Oleksii Leshchenko on 23.09.2022.
//

import SwiftUI
import Combine


class ContentViewModel: ObservableObject {
    
    let passthroughSubject = PassthroughSubject<String, Error>()
    
    let passthroughModelSubject = PassthroughSubject<TimeModel, Error>()
    @Published var time: String = "0 seconds"
    @Published var seconds: String = "0"
    @Published var timeModel = TimeModel(seconds: 0)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        passthroughSubject
            .dropFirst()
            .filter({ (value) -> Bool in
                return value != "5"
            })
            .map { value in
                return value + " seconds"
            }
            .sink { (completion) in
                switch completion {
                case .finished:
                    self.time = "FINISHED"
                case .failure(let error):
                    print(error.localizedDescription)
                    self.time = error.localizedDescription
                }
            } receiveValue: { (value) in
                self.time = "\(value)"
            }
            .store(in: &cancellables)
        
        passthroughModelSubject
            .sink { (completion) in
                print(completion)
            } receiveValue: { (timeModel) in
                print(timeModel)
                self.timeModel = timeModel
            }
            .store(in: &cancellables)

    }
    
    func startFetch() {
        Service.fetch { (result) in
            switch result {
            case .success(let result):
                if result == "10" {
                    self.passthroughSubject.send(completion: .finished)
                } else {
                    self.passthroughSubject.send(result)
                }
                self.seconds = result
            case .failure(let error):
                self.passthroughSubject.send(completion: .failure(error))
                self.seconds = error.localizedDescription
            }
        }
        
        Service.fetchModel { (result) in
            switch result {
            case .success(let timeModel):
                self.passthroughModelSubject.send(timeModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
