//
//  LOReportStackView.swift
//  Layover
//
//  Created by 황지웅 on 12/4/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

final class LOReportStackView: UIStackView {
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
    }

    private func addContent() {
        let contentArray: [String] = ["스팸 홍보 / 도배글이에요", "부적절한 사진이에요", "청소년에게 유해한 내용이에요", "욕설 / 혐오 / 차별적 표현을 담고있어요", "거짓 정보를 담고있어요", "기타"]
        contentArray.forEach { content in
            let loReportContentView: LOReportContentView = LOReportContentView()
            loReportContentView.setText(content)
            addArrangedSubview(loReportContentView)
        }
    }
}
