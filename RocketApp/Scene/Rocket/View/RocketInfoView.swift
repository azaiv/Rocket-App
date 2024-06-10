import UIKit

final class RocketInfoView: UIView {
    
    // - MARK: Source
    typealias DataSource = UITableViewDiffableDataSource<RocketSection, RocketItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<RocketSection, RocketItem>
    
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = nil
    
    
    // - MARK: View
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "defaultHeader")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .clear
        tableView.delegate = self
        return tableView
    }()
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(
            systemName: "gearshape",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withRenderingMode(.alwaysTemplate), 
                        for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    
    // - MARK: Lifecycle
    init(rocket: RocketModel) {
        super.init(frame: .zero)
        
        layer.cornerRadius = UIScreen.main.displayCornerRadius - 10
        layer.cornerCurve = .continuous
        backgroundColor = .systemBackground
        
        setupView()
        configureDataSource()
        applySnapshot(getSection(rocket: rocket))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // - MARK: Setup
    private func setupView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: self.tableView, cellProvider: { tableView, indexPath, item in
            
            switch item {
            case .header(let title):
                guard let cell = self.configureTitleCell(title: title) else {
                    return UITableViewCell()
                }
                return cell
            case .info(let title, let value, _):
                guard let cell = self.configureStageCell(title: title, detail: value) else {
                    return UITableViewCell()
                }
                return cell
            case .button:
                guard let cell = self.configureLaunchesCell() else {
                    return UITableViewCell()
                }
                return cell
            }
            
        })
    }
    
    private func applySnapshot(_ sections: [RocketSection]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<RocketSection, RocketItem>()
        
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.item, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func getSection(rocket: RocketModel) -> [RocketSection] {
        
        return [
            .init(type: .title,
                  item: [.header(title: rocket.name)]),
            
                .init(type: .info,
                      item: [
                        .info(title: Texts.Info.FIRST_LAUNCH_TITLE,
                              value: "\(rocket.firstFlight)", uuid: UUID()),
                        
                            .info(title: Texts.Info.COUNTRY_TITLE,
                                  value: "\(rocket.country)", uuid: UUID()),
                        
                            .info(title: Texts.Info.PRICE_FIRST_LAUNCH,
                                  value: "\(rocket.costPerLaunch)", uuid: UUID())
                        
                      ]),
            
                .init(type: .firstStage,
                      item: [
                        .info(title: Texts.Stage.COUNT_ENGINE_TITLE,
                              value: "\(rocket.firstStage.engines)", uuid: UUID()),
                        
                            .info(title: Texts.Stage.FUEL_AMOUNT_TONS_TITLE,
                                  value: "\(String(describing: rocket.firstStage.fuelAmountTons)) ???", uuid: UUID()),
                        
                            .info(title: Texts.Stage.BURN_TIME_SEC_TITLE,
                                  value: "\(rocket.firstStage.burnTimeSEC ?? 0) ???", uuid: UUID())
                      ]),
            .init(type: .secondStage,
                  item: [
                    .info(title: Texts.Stage.COUNT_ENGINE_TITLE,
                          value: "\(rocket.secondStage.engines)", uuid: UUID()),
                    
                        .info(title: Texts.Stage.FUEL_AMOUNT_TONS_TITLE,
                              value: "\(String(describing: rocket.secondStage.fuelAmountTons)) ???", uuid: UUID()),
                    
                        .info(title: Texts.Stage.BURN_TIME_SEC_TITLE,
                              value: "\(rocket.secondStage.burnTimeSEC ?? 0) ???", uuid: UUID())
                  ]),
            .init(type: .launches,
                  item: [.button])]
    }
    
}

// - MARK: UITableViewDelegate
extension RocketInfoView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = dataSource.sectionIdentifier(for: indexPath.section)?.type
        
        if section == .launches {
            return 60
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = dataSource.sectionIdentifier(for: section)?.type
        
        switch section {
        case .title:
            return nil
        case .physical:
            return nil
        case .info:
            return nil
        case .firstStage:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "defaultHeader")
            header?.textLabel?.text = Texts.Stage.FIRST_STAGE_HEADER.uppercased()
            header?.textLabel?.textColor = .white
            header?.textLabel?.font = .rounded(ofSize: 18, weight: .medium)
            return header
        case .secondStage:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "defaultHeader")
            header?.textLabel?.text = Texts.Stage.SECOND_STAGE_HEADER.uppercased()
            header?.textLabel?.textColor = .white
            header?.textLabel?.font = .rounded(ofSize: 18, weight: .medium)
            return header
        case .launches:
            return nil
        case .none:
            return nil
        }
    }
    
}


// MARK: Configure Cell
extension RocketInfoView {
    
    private func configureTitleCell(title: String) -> UITableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        
        cell?.textLabel?.text = title
        cell?.textLabel?.font = .rounded(ofSize: 28, weight: .medium)
        cell?.backgroundColor = .clear
        cell?.contentView.addSubview(settingsButton)
        cell?.sizeToFit()
        
        settingsButton.sizeToFit()
        settingsButton.frame.origin.x = cell!.contentView.frame.maxX - 18
        settingsButton.center.y = cell!.frame.height / 2
        
        return cell
    }
    
    private func configureStageCell(title: String, detail: String) -> UITableViewCell? {

        let cell =  UITableViewCell(style: .value1, reuseIdentifier: "defaultCell")
 
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .secondaryLabel
        cell.textLabel?.text = title
        cell.textLabel?.font = .rounded(ofSize: 16, weight: .regular)
        cell.detailTextLabel?.text = detail
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.font = .rounded(ofSize: 16, weight: .regular)
        
        return cell
        
    }
    
    private func configureLaunchesCell() -> UITableViewCell? {
        
        let button = LaunchesCustomButton(title: Texts.Launches.LAUNCH_BUTTON_TITLE)
        
        button.backgroundColor = .systemGray6
        button.setTitleColor(.white, for: .normal)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        cell?.backgroundColor = .clear
        
        cell?.contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: cell!.contentView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: cell!.contentView.readableContentGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: cell!.contentView.readableContentGuide.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
   
        return cell
    }
    
}
