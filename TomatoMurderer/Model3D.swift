//
//  Model3D.swift
//  TomatoMurderer
//
//  Created by hendra on 01/05/24.
//

import RealityFoundation
import Combine

class Model3D {
    var name: String
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable?

    init(name: String) {
        self.name = name

        let fileName = name + ".usdz"

        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Success")
                    break
                }
            }, receiveValue: { [weak self] model in
                self?.modelEntity = model
            })
    }
}
