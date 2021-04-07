//
//  MainViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dayStackView: UIStackView!
    @IBOutlet weak var registerEmotionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = [Date?]()
    var emotions: Results<Emotion>?
    var emotionToken: NotificationToken?
    
    // Model
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
        bindModel()
    }
    
    private func setUI() {
        self.title = Date().monthSymoble
        
        Calendar(identifier: .gregorian).shortWeekdaySymbols.forEach { str in
            let label = UILabel()
            label.text = str
            label.textAlignment = .center
            self.dayStackView.addArrangedSubview(label)
        }
        
        // 현재 Month 전후로 3개씩 추가
        (-3...3).forEach { offset in
            self.months.append(Date.getNewMonth(offset: offset, from: Date()))
        }
        
        let initialSection = months.count/2
        if let month = months[initialSection],
           let weeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: month) {
            collectionViewHeight.constant = CGFloat(weeks.count*50)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: initialSection), at: .top, animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmotionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "RegisterEmotionTableViewCell", bundle: nil), forCellReuseIdentifier: "registerCell")
    }
    
    func bindModel() {
        emotions = DatabaseWorker.shared.getEmotionList()
        emotionToken = emotions?.observe { changes in
            switch changes {
            case .update:
                self.tableView.reloadData()
            case .initial:
                self.tableView.reloadData()
            default:
                break
            }
        }
        
        let disposeBag = DisposeBag()
        viewModel.selectedDay
            .subscribe(onNext: { indexPath in
            })
            .disposed(by: disposeBag)
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
    
    // MARK: - Useful Funcs
    /// 달력 section의 첫번째 날 반환
    func getFirstDate(of section: Int) -> Date? {
        let date = months[section] ?? Date()
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: components)
    }
    
    // MARK: - API
    func loadData() {
        API.shared.getUserEmotions { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCollectionViewCell {
            
            if let firstDate = getFirstDate(of: indexPath.section),
               let currentDate = firstDate.getDate(offset: indexPath.item){
                let day = Calendar.current.component(.day, from: currentDate)
                cell.dayLabel.text = "\(day)"
                
                let components: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]
                let firstDay = Calendar.current.dateComponents(components, from: firstDate)
                let currentDay = Calendar.current.dateComponents(components, from: currentDate)
                let today = Calendar.current.dateComponents(components, from: Date())
                
                if firstDay.month == today.month && currentDay.year == today.year && currentDay.month == today.month && currentDay.day == today.day {
                    // 현재 섹션의 month에 해당하고, 오늘 날짜인 경우
                    cell.todayMark.isHidden = false
                }else{
                    cell.todayMark.isHidden = true
                }
                
                if firstDay.month == currentDay.month {
                    cell.dayLabel.textColor = .black
                }else{
                    cell.dayLabel.textColor = .systemGray4
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

// MARK: - UITableDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (emotions?.count ?? 0)+1
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == emotions?.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! RegisterEmotionTableViewCell
            cell.delegate = self
            cell.date = Date()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmotionListTableViewCell
            if let emotion = emotions?[indexPath.row] {
                cell.configure(emotion: emotion.emotionType, comment: emotion.message)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension MainViewController: RegisterEmotionTableViewCellDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterEmotionViewController {
            vc.date = sender as? Date
        }
    }
    
    func didClickRegister(_ date: Date) {
        self.performSegue(withIdentifier: "pushToRegisterEmotion", sender: date)
    }
}
