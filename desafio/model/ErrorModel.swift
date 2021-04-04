//
//  ErrorModel.swift
//  desafio
//
//  Created by João Francisco Muller on 03/04/21.
//

import Foundation

//   let errorModel = try? newJSONDecoder().decode(ErrorModel.self, from: jsonData)
// MARK: - ErrorModel
struct ErrorModel: Codable {
    let statusCode: Int?
    let errorMessage: String
}
