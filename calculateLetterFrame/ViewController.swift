//
//  ViewController.swift
//  calculateLetterFrame
//
//  Created by Chris Evans on 2020/10/5.
//

import UIKit

class ViewController: UIViewController {
    
    var strArr: [String] = []
    
    var fontSize: CGFloat = 20
    
    var tab: UITableView!
    
    let str = """
    Framework
    Core Text
    Create text layouts, optimize font handling, and access font metrics and glyph data.
    Availability

    iOS 3.2+
    macOS 10.8+
    Mac Catalyst 13.0+
    tvOS 9.0+
    watchOS 2.0+
    On This Page

    Overview
    Topics
    See Also
    Overview
    Core Text provides a low-level programming interface for laying out text and handling fonts. The Core Text layout engine is designed for high performance, ease of use, and close integration with Core Foundation. The text layout API provides high-quality typesetting, including character-to-glyph conversion, with ligatures, kerning, and so on. The complementary Core Text font technology provides automatic font substitution (cascading), font descriptors and collections, easy access to font metrics and glyph data, and many other features.

    Note

    All individual functions in Core Text are thread-safe. Font objects (CTFont, CTFontDescriptor, and associated objects) can be used simultaneously by multiple operations, work queues, or threads. However, the layout objects (CTTypesetter, CTFramesetter, CTRun, CTLine, CTFrame, and associated objects) should be used in a single operation, work queue, or thread.
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tab = UITableView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88 - 49 - 34))
        tab.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tab.delegate = self
        tab.dataSource = self
        view.addSubview(tab)
        
        strArr = calculateLetterFrame(str, size: CGSize(width: UIScreen.main.bounds.width, height: 120), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)])
        
        tab.reloadData()
        
        let slider = UISlider(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 49 - 34, width: UIScreen.main.bounds.width, height: 30))
        slider.maximumValue = 100
        slider.minimumValue = 7
        slider.value = 20
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
        // Do any additional setup after loading the view.
    }
    
    func changeFontSize(_ fontSize: CGFloat) {
        
        self.fontSize = fontSize
        
        strArr = calculateLetterFrame(str, size: CGSize(width: UIScreen.main.bounds.width, height: 120), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)])
        
        tab.reloadData()
    }
    
    @objc private func sliderValueChanged(_ sli: UISlider) {
        
        changeFontSize(CGFloat(sli.value))
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return strArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.setData(strArr[indexPath.row], font: UIFont.systemFont(ofSize: fontSize))
        return cell
    }
}

class TableViewCell: UITableViewCell {
    
    private let txtView = UILabel()
    
    func setData(_ str: String, font: UIFont) {
        
        txtView.text = str
        txtView.font = font
        txtView.lineBreakMode = .byClipping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        txtView.frame = bounds
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        txtView.textColor = .black
        txtView.numberOfLines = 0
        addSubview(txtView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
