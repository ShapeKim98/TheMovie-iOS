//
//  SettingViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import SnapKit

protocol SettingViewControllerDelegate: AnyObject {
    func withdrawButtonTouchUpInside()
}

final class SettingViewController: UIViewController {
    private let profileView = TMProfileView()
    private let tableView = UITableView()
    
    private let items = SettingItem.allCases
    
    private let viewModel = SettingViewModel()
    
    weak var delegate: (any SettingViewControllerDelegate)?
    
    deinit { print("SettingViewController deinitialized") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileView.updateProfile()
        profileView.updateMovieBoxLabel()
    }
}

// MARK: Configure Views
private extension SettingViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        configureProfileView()
        
        configureTableView()
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "설정"
    }
    
    func configureProfileView() {
        profileView.addButtonAction { [weak self] _ in
            self?.profileViewButtonTouchUpInside()
        }
        view.addSubview(profileView)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorColor = .tm(.semantic(.border(.tertiary)))
        tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: .settingTableCell
        )
        tableView.backgroundColor = .clear
        tableView.overrideUserInterfaceStyle = .dark
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
}

// MARK: Data Bindings
private extension SettingViewController {
    func dataBinding() {
        let outputs = viewModel.output
        
        Task { [weak self] in
            for await output in outputs {
                switch output {
                case let .isPresentWithdrawAlert(isPresentWithdrawAlert):
                    self?.bindIsPresentWithdrawAlert(isPresentWithdrawAlert)
                }
            }
        }
    }
    
    func bindIsPresentWithdrawAlert(_ isPresentWithdrawAlert: Bool) {
        guard isPresentWithdrawAlert else { return }
        let alert = UIAlertController(
            title: "탈퇴하기",
            message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .destructive,
            handler: { [weak self] _ in
                self?.withdrawButtonTouchUpInside()
            }
        )
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: { [weak self] _ in
                self?.cancelButtonTouchUpInside()
            }
        )
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.overrideUserInterfaceStyle = .dark
        UINotificationFeedbackGenerator()
            .notificationOccurred(.warning)
        present(alert, animated: true)
    }
}

// MARK: Functions
private extension SettingViewController {
    func profileViewButtonTouchUpInside() {
        let viewController = ProfileViewController(mode: .edit)
        viewController.delegate = self
        let navigation = navigation(viewController)
        present(navigation, animated: true)
    }
    
    func withdrawButtonTouchUpInside() {
        viewModel.input(.withdrawButtonTouchUpInside)
        delegate?.withdrawButtonTouchUpInside()
    }
    
    func cancelButtonTouchUpInside() {
        viewModel.input(.cancelButtonTouchUpInside)
    }
}

extension SettingViewController: UITableViewDelegate,
                                 UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .settingTableCell,
            for: indexPath
        ) as? SettingTableViewCell
        guard let cell else { return UITableViewCell() }
        let item = items[indexPath.row]
        if item != .탈퇴하기 {
            cell.selectionStyle = .none
        }
        cell.forRowAt(item.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        guard item == .탈퇴하기 else { return }
        viewModel.input(.tableViewDidSelectRowAt)
    }
}

extension SettingViewController: ProfileViewControllerDelegate {
    func dismiss() {
        profileView.updateProfile()
    }
}

private extension SettingViewController {
    enum SettingItem: CaseIterable {
        case 자주_묻는_질문
        case 일대일_문의
        case 알림_설정
        case 탈퇴하기
        
        var title: String {
            switch self {
            case .자주_묻는_질문: return "자주 묻는 질문"
            case .일대일_문의: return "1:1 문의"
            case .알림_설정: return "알림 설정"
            case .탈퇴하기: return "탈퇴하기"
            }
        }
    }
}

fileprivate extension String {
    static let settingTableCell = "SettingTableViewCell"
}

@available(iOS 17.0, *)
#Preview {
    SettingViewController()
}
