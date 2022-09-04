//
//  ViewController.swift
//  Today_App
//
//  Created by Hai Tran Phi on 8/5/22.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var filtereReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }
    .sorted { $0.dueDate < $1.dueDate }
    }
    
    var listStyle: ReminderListtyle = .today
    let listStyleSegmentedControl = UISegmentedControl(items: [ReminderListtyle.today.name, ReminderListtyle.future.name, ReminderListtyle.all.name])
    var headerView: ProgressHeaderView?
    // Thuộc tính được tính toán
    var progress: CGFloat {
        let chunkSise = 1.0 / CGFloat(filtereReminders.count)
        let progress = filtereReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSise : 0
            return $0 + chunk
        }
        return progress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        //Thêm vào nguồn dữ liệu sử dụng đăng ký chế độ xem tiêu đề mới
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
             dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
                 return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
             }
            
        let addbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addbutton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibilyty label")
        navigationItem.rightBarButtonItem = addbutton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filtereReminders[indexPath.item].id
        showDetail(for: id)
        return false
    }
    // Hệ thống phương thức này khi chế độ xem collection sắp hiển thị chế độ xem
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
       // Sử dụng một guardcâu lệnh để kiểm tra xem loại phần tử có phải là dạng xem tiến trình hay không. Nếu không, hãy quay lại điểm gọi hàm.
       // Toán tử ép kiểu as?có điều kiện truyền xuống viewtừ kiểu sang .UICollectionReusableViewProgressHeaderView
        guard elementKind == ProgressHeaderView.elementKind, let progressView = view as? ProgressHeaderView else {
            return
        }
        // Cập nhật thuộc tính
        progressView.progress = progress
    }
    
    func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary // Thay đổi chế độ tiêu đề để xác định loại tiêu  đề
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeAction
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
}
