//
//  OnboardViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

import SnapKit

final class OnboardViewController: UIViewController {
    private let onboardImageView = UIImageView()
    private let onboardLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = TMBoarderButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: Configure Views
private extension OnboardViewController {
    func configureUI() {
        view.backgroundColor = .black
        
        configureOnBoardImageView()
        
        configureOnBoardLabel()
        
        configureDescriptionLabel()
        
        configureStartButton()
    }
    
    func configureLayout() {
        onboardImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        onboardLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onboardImageView.snp.bottom).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onboardLabel.snp.bottom).offset(20)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
        }
    }
    
    func configureOnBoardImageView() {
        onboardImageView.image = .tm(.onboarding)
        onboardImageView.contentMode = .scaleAspectFit
        view.addSubview(onboardImageView)
    }
    
    func configureOnBoardLabel() {
        onboardLabel.text = "Onboarding"
        onboardLabel.font = .italicBoldSystemFont(ofSize: 28)
        onboardLabel.textColor = .tm(.white)
        view.addSubview(onboardLabel)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.text = "당신만의 영화세상,\nThe Movie를 시작해보세요."
        descriptionLabel.textColor = .tm(.white)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .tm(.subheadline)
        view.addSubview(descriptionLabel)
    }
    
    func configureStartButton() {
        startButton.addTarget(
            self, action: #selector(startButtonTouchUpInside),
            for: .touchUpInside
        )
        view.addSubview(startButton)
    }
}

// MARK: Functions
private extension OnboardViewController {
    @objc
    func startButtonTouchUpInside() {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    OnboardViewController()
}
