//
//  EditorTableViewController.swift
//  stts
//
//  Created by inket on 8/11/16.
//  Copyright © 2016 inket. All rights reserved.
//

import Cocoa
import SnapKit

class EditorTableViewController: NSObject {
    let contentView: NSStackView
    let scrollView: CustomScrollView
    let tableView = NSTableView()

    var allServices: [Service] = Service.all().sorted()
    var selectedServices: [Service] = Preferences.shared.selectedServices

    var selectionChanged = false

    let settingsView = SettingsView()

    init(contentView: NSStackView, scrollView: CustomScrollView) {
        self.contentView = contentView
        self.scrollView = scrollView

        super.init()
        setup()
    }

    func setup() {
        tableView.frame = scrollView.bounds
        let column = NSTableColumn(identifier: "editorColumnIdentifier")
        column.width = 200
        tableView.addTableColumn(column)
        tableView.autoresizesSubviews = true
        tableView.wantsLayer = true
        tableView.layer?.cornerRadius = 6
        tableView.headerView = nil
        tableView.rowHeight = 30
        tableView.gridColor = NSColor.green
        tableView.gridStyleMask = NSTableViewGridLineStyle.init(rawValue: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.selectionHighlightStyle = .none

        contentView.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(100)
        }
    }

    func showTableView() {
        self.selectionChanged = false

        scrollView.topConstraint?.update(offset: 100)
        scrollView.documentView = tableView

        (NSApp.delegate as? AppDelegate)?.popupController.resizePopup(width: 220)

        tableView.frame = scrollView.bounds
        tableView.tableColumns.first?.width = tableView.frame.size.width

        settingsView.isHidden = false
    }
}

extension EditorTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return allServices.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }
}

extension EditorTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier ?? "identifier"
        let cell = tableView.make(withIdentifier: identifier, owner: self) ?? EditorTableCell()

        guard let view = cell as? EditorTableCell else { return nil }

        let service = allServices[row]
        view.textField?.stringValue = service.name
        view.selected = selectedServices.contains(service)
        view.toggleCallback = { [weak self] in
            guard let selfie = self else { return }

            selfie.selectionChanged = true

            if view.selected {
                self?.selectedServices.append(service)
            } else {
                if let index = self?.selectedServices.index(of: service) {
                    self?.selectedServices.remove(at: index)
                }
            }

            Preferences.shared.selectedServices = selfie.selectedServices
        }

        return view
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let cell = tableView.make(withIdentifier: "rowView", owner: self) ?? ServiceTableRowView()

        guard let view = cell as? ServiceTableRowView else { return nil }

        view.showSeparator = row + 1 < allServices.count

        return view
    }
}
