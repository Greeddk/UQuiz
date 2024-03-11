//
//  MainTabBarController.swift
//  UQuiz
//
//  Created by Greed on 3/10/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    enum MainTabBarMenu: CaseIterable {
        case QuizList
        case MakeQuiz
        case Setting
        
        var viewController: UIViewController {
            switch self {
            case .QuizList:
                return UINavigationController(rootViewController: QuizListViewController())
            case .MakeQuiz:
                return UINavigationController(rootViewController: MovieSearchViewController())
            case .Setting:
                return UINavigationController(rootViewController: SettingViewController())
            }
        }
        
        var tabBarIcon: UIImage! {
            switch self {
            case .QuizList:
                return UIImage(systemName: "list.dash")?.withBaselineOffset(fromBottom: 15)
            case .MakeQuiz:
                return UIImage(systemName: "plus.circle")?.withBaselineOffset(fromBottom: 20)
            case .Setting:
                return UIImage(systemName: "person.fill")?.withBaselineOffset(fromBottom: 18)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuList = MainTabBarMenu.allCases
        let viewControllers = menuList.map { $0.viewController }
        
        for index in 0...viewControllers.count - 1 {
            viewControllers[index].tabBarItem.image = menuList[index].tabBarIcon
        }
        
        tabBar.layer.borderColor = UIColor.green.cgColor
        tabBar.layer.borderWidth = 1
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.layer.borderWidth = 1
        
        setViewControllers(viewControllers, animated: true)
    }

}
