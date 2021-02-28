//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
    }
    
    private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: 50)
        layout.scrollDirection = .vertical
        return layout
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            let components = Calendar.current.dateComponents([.year, .month], from: Date())
            if let firstDate = Calendar.current.date(from: components) {
                let weekDay = Calendar.current.component(.weekday, from: firstDate)
                let dayOffset = indexPath.item-(weekDay-1)
                let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: firstDate, wrappingComponents: false)
                print(newDate)
                let day = Calendar.current.component(.day, from: newDate!)
                cell.dayLabel.text = "\(day)"
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        currentMonth = indexPath.section
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: Date())
        print(weeks!.count*7)
        return weeks!.count*7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
