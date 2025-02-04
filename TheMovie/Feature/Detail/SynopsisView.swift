//
//  SynopsisView.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import SnapKit

protocol SynopsisViewDelegate: AnyObject {
    func moreButtonTouchUpInside()
}

final class SynopsisView: UIView {
    private let titleLabel = UILabel()
    private let moreButton = UIButton()
    private let overviewLabel = UILabel()
    
    weak var delegate: (any SynopsisViewDelegate)?
    
    init(overview: String) {
        super.init(frame: .zero)
        
        configureUI(overview: overview)
        
        configureLayout(overview: overview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
private extension SynopsisView {
    func configureUI(overview: String) {
        configureTitleLabel()
        
        configureOverviewLabel(overview: overview)
        
        guard !overview.isEmpty else { return }
        configureMoreButton()
    }
    
    func configureLayout(overview: String) {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        guard !overview.isEmpty else { return }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Synopsis"
        titleLabel.textColor = .tm(.semantic(.text(.primary)))
        titleLabel.font = .tm(.headline)
        addSubview(titleLabel)
    }
    
    func configureMoreButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = .make("More", [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.tm(.semantic(.text(.brand)))
        ])
        moreButton.configuration = configuration
        moreButton.addAction(
            UIAction(handler: moreButtonTouchUpInside),
            for: .touchUpInside
        )
        addSubview(moreButton)
    }
    
    func configureOverviewLabel(overview: String) {
        if overview.isEmpty {
            overviewLabel.text = "영화 줄거리가 없어요."
            overviewLabel.textColor = .tm(.semantic(.text(.tertiary)))
            overviewLabel.textAlignment = .center
        } else {
            overviewLabel.text = overview
            overviewLabel.numberOfLines = 3
            overviewLabel.textColor = .tm(.semantic(.text(.primary)))
        }
        overviewLabel.font = .tm(.body)
        addSubview(overviewLabel)
    }
}

// MARK: Functions
private extension SynopsisView {
    func moreButtonTouchUpInside(_ action: UIAction) {
        let lines = overviewLabel.numberOfLines
        overviewLabel.numberOfLines = lines == 3 ? 0 : 3
        UIView.fadeAnimate(duration: 0.4) { [weak self] in
            guard let `self` else { return }
            overviewLabel.alpha = 0
            overviewLabel.alpha = 1
            moreButton.configuration?.attributedTitle = .make(lines == 3 ? "Hide" : "More", [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor.tm(.semantic(.text(.brand)))
            ])
        }
        delegate?.moreButtonTouchUpInside()
    }
}

@available(iOS 17.0, *)
#Preview {
    DetailViewController(.mock)
}
