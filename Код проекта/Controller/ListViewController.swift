//
//  ListViewController.swift
//  MultipleSections
//
//  Created by Алексей Пархоменко on 13.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    let sections = Bundle.main.decode([MSection].self, from: "model.json")
    var collectionView:UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MSection, MChat>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createDataSource()
        relodeData()
        view.backgroundColor = .orange
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        
    }
//MARK: - Setup collectionView
    func setupCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayut())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
    }
//MARK: - Create DataSorce(UICollectionViewDiffableDataSource)
    func createDataSource(){
        dataSource = UICollectionViewDiffableDataSource<MSection, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            switch self.sections[indexPath.section].type{
            case "activeChats":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveChatCell.reuseId, for: indexPath) as? ActiveChatCell
                cell?.configure(with: chat)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingChatCell.reuseId, for: indexPath) as? WaitingChatCell
                cell?.configure(with: chat)
                return cell
            }
                
        })
        //MARK: - work with sectionHeader
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath  in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { return nil}
            guard let firstChat = self.dataSource?.itemIdentifier(for: indexPath) else { return nil}
            guard let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstChat) else {return nil}
            if section.title.isEmpty {return nil}
            sectionHeader.title.text = section.title
            return sectionHeader
        }
    }
//MARK: - RelodeData(NSDiffableDataSourceSnapshot)
    func relodeData(){
        var snapshot = NSDiffableDataSourceSnapshot<MSection,MChat>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
//MARK: - Setup Layout
    func createCompositionalLayut() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) ->  NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            switch section.type{
            case "activeChats":
                return self.createActiveChatSection()
            default:
                return self.createWaitingChatSection()
            }
        }
        return layout
    }
//MARK: - createWaitingChatSecction(NSCollectionLayoutSection)
    func createWaitingChatSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104), heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 0, trailing: 12)
        
        //MARK: - Create Header
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        return layoutSection
        
    }
//MARK: - createActiveChatSection(NSCollectionLayoutSection)
    func createActiveChatSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 20, bottom: 0, trailing: 20)
        //MARK: - Create Header
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return layoutSectionHeader
    }
}
// MARK: - SwiftUI
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let listVC = ListViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> ListViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
            
        }
    }
}



