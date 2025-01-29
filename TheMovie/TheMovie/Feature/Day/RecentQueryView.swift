//
//  RecentQueryView.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

protocol RecentQueryViewDelegate: AnyObject {
    func textButtonTouchUpInside(text: String)
}

final class RecentQueryView: UIView {
    private let titleLabel = UILabel()
    private let removeAllButton = UIButton()
    private let emptyLabel = UILabel()
    private let contentView = UIStackView()
    private let scrollView = UIScrollView()
    private var queryButtons = [QueryButton]()
    
    @UserDefault(forKey: .userDefaults(.recentQueries))
    private var recentQueries: [String]? {
        didSet { didSetRecentQueries() }
    }
    
    weak var delegate: (any RecentQueryViewDelegate)?
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        for button in queryButtons {
            button.layoutIfNeeded()
        }
    }
    
    func updateQueryButton() {
        for button in queryButtons {
            contentView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        queryButtons.removeAll()
        for query in recentQueries ?? [] {
            let button = QueryButton(text: query)
            button.delegate = self
            queryButtons.append(button)
            contentView.addArrangedSubview(button)
        }
        contentView.layoutIfNeeded()
    }
}

// MARK: Configure Views
private extension RecentQueryView {
    func configureUI() {
        configureTitleLabel()
        
        configureRemoveAllButton()
        
        configureEmptyLabel()
        
        configureScrollView()
        
        configureContentView()
        
        configureQueryButtons()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView).offset(24)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        for button in queryButtons {
            button.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
            }
        }
    }
    
    func configureTitleLabel() {
        titleLabel.text = "최근 검색어"
        titleLabel.textColor = .tm(.semantic(.text(.primary)))
        titleLabel.font = .tm(.title)
        addSubview(titleLabel)
    }
    
    func configureRemoveAllButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = .make("전체 삭제", [
            .foregroundColor: UIColor.tm(.semantic(.text(.brand))),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ])
        removeAllButton.configuration = configuration
        removeAllButton.isHidden = (recentQueries?.isEmpty ?? true)
        removeAllButton.addAction(
            UIAction(handler: removeAllButtonTouchUpInside),
            for: .touchUpInside
        )
        addSubview(removeAllButton)
    }
    
    func configureEmptyLabel() {
        emptyLabel.text = "최근 검색어 내역이 없습니다."
        emptyLabel.textColor = .tm(.semantic(.text(.tertiary)))
        emptyLabel.font = .tm(.caption)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = !(recentQueries?.isEmpty ?? true)
        addSubview(emptyLabel)
    }
    
    func configureScrollView() {
        scrollView.isHidden = (recentQueries?.isEmpty ?? true)
        addSubview(scrollView)
    }
    
    func configureContentView() {
        contentView.axis = .horizontal
        contentView.distribution = .fill
        contentView.spacing = 8
        scrollView.addSubview(contentView)
    }
    
    func configureQueryButtons() {
        guard let recentQueries else { return }
        for query in recentQueries {
            let button = QueryButton(text: query)
            button.delegate = self
            queryButtons.append(button)
            contentView.addArrangedSubview(button)
        }
    }
}

// MARK: Data Bindings
private extension RecentQueryView {
    func didSetRecentQueries() {
        let isEmpty = recentQueries?.isEmpty ?? true
        UIView.fadeAnimate { [weak self] in
            guard let `self` else { return }
            scrollView.alpha = isEmpty ? 0 : 1
            emptyLabel.alpha = isEmpty ? 1 : 0
        } completion: { [weak self] _ in
            guard let `self` else { return }
            scrollView.isHidden = isEmpty
            emptyLabel.isHidden = !isEmpty
        }
    }
}

// MARK: Functions
private extension RecentQueryView {
    func removeAllButtonTouchUpInside(_ action: UIAction) {
        recentQueries?.removeAll()
    }
}

extension RecentQueryView: QueryButtonDelegate {
    func textButtonTouchUpInside(text: String) {
        delegate?.textButtonTouchUpInside(text: text)
    }
    
    func removeButtonTouchUpInside(text: String) {
        print(#function)
        recentQueries?.removeAll(where: { $0 == text })
        guard let index = queryButtons.firstIndex(where: { $0.text == text }) else {
            return
        }
        let removedButton = queryButtons.remove(at: index)
        contentView.removeArrangedSubview(removedButton)
        UIView.fadeAnimate {
            removedButton.alpha = 0
        } completion: { _ in
            removedButton.removeFromSuperview()
        }
        
        UIView.springAnimate { [weak self] in
            guard let `self` else { return }
            scrollView.layoutIfNeeded()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
