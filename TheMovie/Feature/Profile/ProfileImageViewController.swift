//
//  ProfileImageViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/26/25.
//

import UIKit

import SnapKit

final class ProfileImageViewController: UIViewController {
    private let selectedProfileView: TMProfileButton
    private lazy var profileCollectionView = {
        configureCollectionView()
    }()
    
    private let viewModel: ProfileImageViewModel
    
    init(title: String, viewModel: ProfileImageViewModel) {
        self.viewModel = viewModel
        self.selectedProfileView = TMProfileButton(
            self.viewModel.model.selectedId,
            size: 100
        )
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { print("ProfileImageViewController deinitialized") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        dataBinding()
    }
}

// MARK: Configure Views
private extension ProfileImageViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureSelectedProfileView()
    }
    
    func configureLayout() {
        selectedProfileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedProfileView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureSelectedProfileView() {
        selectedProfileView.isSelected = true
        view.addSubview(selectedProfileView)
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let global = view.frame
        let spacing = CGFloat(16)
        let width = (global.width - 40 - 3 * spacing) / 4
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ProfileImageCollectionViewCell.self,
            forCellWithReuseIdentifier: .profileImageCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        return collectionView
    }
}

// MARK: Data Bindings
private extension ProfileImageViewController {
    func dataBinding() {
        let outputs = viewModel.output
        
        Task { [weak self] in
            for await output in outputs {
                switch output {
                case let .selectedId(oldValue, newValue):
                    self?.bindedSelectedId(oldValue, newValue)
                }
            }
        }
    }
    
    func bindedSelectedId(_ oldValue: Int, _ newValue: Int) {
        selectedProfileView.setProfile(id: newValue)
        
        let deSelectedIndexPath = IndexPath(item: oldValue, section: 0)
        profileCollectionView.deselectItem(
            at: deSelectedIndexPath,
            animated: true
        )
        
        let indexPath = IndexPath(item: newValue, section: 0)
        profileCollectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: []
        )
    }
}

extension ProfileImageViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .profileImageCollectionCell,
            for: indexPath
        ) as? ProfileImageCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        
        cell.forItemAt(indexPath.item)
        if viewModel.model.selectedId == indexPath.item {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input(.collectionViewDidSelectItemAt(item: indexPath.item))
    }
}

fileprivate extension String {
    static let profileImageCollectionCell = "ProfileImageCollectionViewCell"
}

@available(iOS 17.0, *)
#Preview {
    ProfileImageViewController(title: "프로필 이미지 설정", viewModel: .init(selectedId: 0))
}
