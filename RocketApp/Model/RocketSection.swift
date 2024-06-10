import Foundation

enum Sections {
    case title
    case physical
    case info
    case firstStage
    case secondStage
    case launches
}

enum RocketItem: Hashable {
    case header(title: String)
    case info(title: String, value: String, uuid: UUID = UUID())
    case button
}

struct RocketSection: Hashable {
    let type: Sections
    let item: [RocketItem]
}
