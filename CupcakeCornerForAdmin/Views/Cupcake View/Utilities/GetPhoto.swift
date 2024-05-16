//
//  GetPhoto.swift
//  CupcakeCornerForAdmin
//
//  Created by Isaque da Silva on 03/05/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct GetPhoto {
    static func getImage(_ pickerItemSelected: PhotosPickerItem) async throws -> (Data?, UIImage?) {
        let task = Task<(Data?, UIImage?), Error> {
            if let data = try? await pickerItemSelected.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    return (data, image)
                } else {
                    return (nil, nil)
                }
            } else {
                return (nil, nil)
            }
        }
        
        return try await task.value
    }
}
