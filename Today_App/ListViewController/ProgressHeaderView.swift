//
//  ProgressHeaderView.swift
//  Today_App
//
//  Created by Hai Tran Phi on 9/4/22.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    // Tạo thuộc tính
    var progress: CGFloat = 0 {
        didSet {
            // Làm vô hiệu hoá kích thước hiện tại và kích hoạt cập nhật setNeedsLayout
            setNeedsLayout()
            // Thêm quan sát vào thuộc progress cập nhật giới hạn chiều cao của chế độ xem thấp hơn khi giá trị progress thay đổi
            heightConstraint?.constant = progress * bounds.height
            // Tạo hoạt ảnh cho các thay đổi
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    //Thêm các thuộc tính
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private var heightConstraint: NSLayoutConstraint?
    private var valueFormat: String {NSLocalizedString("%d percent", comment: "progress percentage value format")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        
        isAccessibilityElement = true // kt phần tử có phải là pt hỗ trợ mà công nghệ hỗ trợ có thể truy cập hay không
        accessibilityLabel = NSLocalizedString("Progress", comment: "progress view accessibility label")
        accessibilityTraits.update(with: .updatesFrequently)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessibilityValue = String(format: valueFormat, Int(progress * 100.0))// gán chuỗi mới để sử dụng giá trị
        heightConstraint?.constant = progress * bounds.height // Fix bug chế độ hiển thị lần đầu tiên
        containerView.layer.masksToBounds = true
        // Điều chỉnh bán kính góc
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
    //Tạo hàm để thêm các chế độ xem vào hệ thống phân cấp
    private func prepareSubviews() {
        
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        // Vô hiệu hoá các lượt xem phụ để có thể sửa đổi các ràng buộc
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // Chia tỷ lệ cố định 1:1
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        // Canh giữa chế độ xem theo chiều ngang và chiều dọc
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        // Chia tỷ lệ xem vùng chứa 85%
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        // Ràng buộc theo chiều dọc
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        // Ràng buộc theo chiều ngang
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        // Tạo ràng buộc chiều cao và gán kích thước nó bằng 0
        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        // Gán màu nền cho khung hình
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .todayProgressUpperBackground
        upperView.backgroundColor = .todayProgressLowerBackground
    }
    
}
