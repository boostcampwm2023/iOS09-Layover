//
//  LOReportStackView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOReportStackView: UIStackView {

    var reportViews: [LOReportContentView] = {
        let contentArray: [String] = ["스팸 홍보 / 도배글이에요", "부적절한 사진이에요", "청소년에게 유해한 내용이에요", "욕설 / 혐오 / 차별적 표현을 담고있어요", "거짓 정보를 담고있어요", "기타"]
        return contentArray.enumerated().map { index, content in
            let loReportContentView: LOReportContentView = LOReportContentView()
            loReportContentView.setText(content)
            loReportContentView.index = index
            return loReportContentView
        }
    }()

    var reportContent: String = "스팸 홍보 / 도배글이에요"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        addContent()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        addContent()
    }

    private func setUI() {
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.axis = .vertical
        self.spacing = 8
        guard let firstReportView: LOReportContentView = reportViews.first else { return }
        firstReportView.onRadio()
    }

    private func addContent() {
        reportViews.forEach { reportView in
            let addGesutre: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reportViewDidTap(_:)))
            reportView.addGestureRecognizer(addGesutre)
            addArrangedSubview(reportView)
        }
    }

    @objc private func reportViewDidTap(_ sender: UITapGestureRecognizer) {
        guard let tempView: LOReportContentView = sender.view as? LOReportContentView else { return }
        self.reportViews.forEach { reportView in
            if reportView.index == tempView.index {
                reportView.onRadio()
                guard let reportContentText: String = reportView.contentLabel.text else { return }
                reportContent = reportContentText
            } else {
                reportView.offRadio()
            }
        }
    }
}
