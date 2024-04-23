//
//  PageController.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 21/04/24.
//

import Combine
import Foundation

final class PageController: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAuthorized = false
    
    func setNewValue(_ isAuthorizedStatus: Bool) {
        UserDefaults.standard.set(isAuthorizedStatus, forKey: Keys.authorized.rawValue)
        isAuthorized = isAuthorizedStatus
    }
    
    private func observe() {
        $isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                
            }
    }
}

extension ProfileView {
    @Observable
    final class ViewModel {
        var isAuthorized: Bool {
            UserDefaults.standard.bool(forKey: Keys.authorized.rawValue)
        }
    }
}
