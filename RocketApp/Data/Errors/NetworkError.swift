import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidData
    case invalidDecoding
}
