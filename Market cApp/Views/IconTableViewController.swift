//
//  IconTableViewController.swift
//  Market cApp
//
//  Created by David on 1/2/21.
//

import UIKit

class IconTableViewController: UITableViewController {
    
    var icons = [Icon(image: UIImage(named: "defaultIcon")!, fileName: "defaultIcon", title: "Light Gray + Indigo (Default)", isSelectedIcon: false), Icon(image: UIImage(named: "altIcon1")!, fileName: "altIcon1", title: "Light Gray + Dark Gray", isSelectedIcon: false), Icon(image: UIImage(named: "altIcon2")!, fileName: "altIcon2", title: "Dark Gray + Indigo", isSelectedIcon: false), Icon(image: UIImage(named: "altIcon3")!, fileName: "altIcon3", title: "Indigo + Black", isSelectedIcon: false), Icon(image: UIImage(named: "altIcon4")!, fileName: "altIcon4", title: "Indigo + Light Gray", isSelectedIcon: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAppearance()
        setSelectedAppIcon()
    }
    
    func setSelectedAppIcon() {
        let defaults = UserDefaults.standard
        let iconSelection = defaults.integer(forKey: "iconSelection")
        icons[iconSelection].isSelectedIcon = true
    }
    
    func setAppearance() {
        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "appearanceSelection")
        
        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath)
        
        let icon = icons[indexPath.row]
        
        cell.imageView?.image = icon.image
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.heightAnchor.constraint(equalToConstant: 57).isActive = true
        cell.imageView?.widthAnchor.constraint(equalToConstant: 57).isActive = true
        cell.imageView?.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        cell.imageView?.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        cell.imageView?.layer.cornerRadius = 13
        cell.imageView?.clipsToBounds = true
        cell.accessoryType = icon.isSelectedIcon ? .checkmark : .none
        cell.tintColor = .systemIndigo
        cell.textLabel?.text = icon.title
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        cell.textLabel?.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 77).isActive = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !icons[indexPath.row].isSelectedIcon else {
            print("icon already selected")
            return
        }
        
        print("\(indexPath) cell selected")
        if let currentSelectedIconIndex = icons.firstIndex(where: {$0.isSelectedIcon == true}) {
            icons[currentSelectedIconIndex].isSelectedIcon = false
        }
        
        icons[indexPath.row].isSelectedIcon = true
        
        switch indexPath.row {
        case 0:
            print("default icon row tapped")
            UIApplication.shared.setAlternateIconName(nil) { (error) in
                guard error == nil else {
                    print("Error setting app icon: \(error!.localizedDescription)")
                    return
                }
                
            }
        default:
            print("default case triggered")
            print("icon should be changed to: \(icons[indexPath.row].fileName)")
            
            UIApplication.shared.setAlternateIconName("\(icons[indexPath.row].fileName)") { (error) in
                guard error == nil else {
                    print("Error setting app icon: \(error!.localizedDescription)")
                    return
                }
                print("success changing icon")
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.setValue(indexPath.row, forKey: "iconSelection")
        tableView.reloadData()
    }
}
