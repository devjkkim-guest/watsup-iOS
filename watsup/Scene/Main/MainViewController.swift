//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dayStackView: UIStackView!
    @IBOutlet weak var registerEmotionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = [Date?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Date().monthSymoble
        (-3...3).forEach { offset in
            self.months.append(Date.getNewMonth(offset: offset, from: Date()))
        }
        
        let initialSection = months.count/2
        if let month = months[initialSection],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            collectionViewHeight.constant = CGFloat(weeks.count*50)
        }
        setUI()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: initialSection), at: .top, animated: false)
        self.view.addSubview(UIView())
        
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue) {
            API.shared.getUserEmotions(GetUserEmotionsRequest(user_uuid: uuid)) { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUI() {
        Calendar(identifier: .gregorian).shortWeekdaySymbols.forEach { str in
            let label = UILabel()
            label.text = str
            label.textAlignment = .center
            self.dayStackView.addArrangedSubview(label)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmotionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
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
    
    private func getCurrentWeeks(in scrollView: UIScrollView) -> Int? {
        let indexPaths = self.collectionView.indexPathsForVisibleItems
            .sorted { $0.section < $1.section }
        if let month = months[indexPaths[indexPaths.count/2].section],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            return weeks.count
        }else{
            return nil
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            let date = months[indexPath.section] ?? Date()
            let components = Calendar.current.dateComponents([.year, .month], from: date)
            if let firstDate = Calendar.current.date(from: components) {
                let weekDay = Calendar.current.component(.weekday, from: firstDate)
                let dayOffset = indexPath.item-(weekDay-1)
                if let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: firstDate, wrappingComponents: false) {
                    let day = Calendar.current.component(.day, from: newDate)
                    cell.dayLabel.text = "\(day)"
                    
                    let components: Set = [Calendar.Component.month, Calendar.Component.day]
                    let today = Calendar.current.dateComponents(components, from: Date())
                    let newDay = Calendar.current.dateComponents(components, from: newDate)
                    
                    if newDay.month == today.month && newDay.day == today.day {
                        cell.todayMark.isHidden = false
                    }else{
                        cell.todayMark.isHidden = true
                    }
                }
                
                if dayOffset < 0 || dayOffset >= Calendar.current.component(.day, from: date.endOfMonth) {
                    cell.dayLabel.textColor = .lightGray
                }else{
                    cell.dayLabel.textColor = .black
                }
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let month = months[section],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            return weeks.count*7
        }else{
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EmotionListTableViewCell {
            let comments = ["😅 공무원은 국민전체에 대한 봉사자이며, 국민에 대하여 책임을 진다. 국회는 정부의 동의없이 정부가 제출한 지출예산 각항의 금액을 증가하거나 새 비목을 설치할 수 없다.",
                            "😅 모든 국민은 법률이 정하는 바에 의하여 공무담임권을 가진다. 대한민국의 주권은 국민에게 있고, 모든 권력은 국민으로부터 나온다.",
                            "😅 하하하",
                            "😅 국회의 회의는 공개한다.",
                            "😅 모든 국민은 통신의 비밀을 침해받지 아니한다. 누구든지 체포 또는 구속을 당한 때에는 즉시 변호인의 조력을 받을 권리를 가진다. "]
            cell.configure(day: indexPath.row+1, comment: comments[indexPath.row%5])
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffset = scrollView.contentSize.height-scrollView.frame.height
        if scrollView == collectionView {
            if scrollView.contentOffset.y < 200 {
                if let firstDate = months.first,
                   let date = firstDate {
                    print("previous data added")
                    months.insert(Date.getNewMonth(offset: -1, from: date), at: 0)
                    months.insert(Date.getNewMonth(offset: -2, from: date), at: 0)
                    let oldContentSize = collectionView.contentSize
                    collectionView.reloadData()
                    collectionView.layoutIfNeeded()
                    let newContentSize = collectionView.contentSize
                    let contentOffsetY = collectionView.contentOffset.y + newContentSize.height - oldContentSize.height
                    let newOffset = CGPoint(x: collectionView.contentOffset.x, y: contentOffsetY)
                    collectionView.setContentOffset(newOffset, animated: false)
                }
            }
            if scrollView.contentOffset.y > maxOffset-200 {
                if let lastDate = months.last,
                   let date = lastDate {
                    print("next months added")
                    months.append(Date.getNewMonth(offset: 1, from: date))
                    months.append(Date.getNewMonth(offset: 2, from: date))
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            // 중앙 지점의 섹션으로 이동
            let indexPaths = self.collectionView.indexPathsForVisibleItems
                .sorted { $0.section < $1.section }
            let center = indexPaths[indexPaths.count/2]
            targetContentOffset.pointee.y = scrollView.contentOffset.y
            collectionView.scrollToItem(at: IndexPath(item: 0, section: center.section), at: .top, animated: true)
            
            if let date = months[center.section] {
                self.title = date.monthSymoble
            }
        }
        
        if let weeks = getCurrentWeeks(in: scrollView) {
            let height = CGFloat(50*weeks)
            self.collectionViewHeight.constant = height
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
