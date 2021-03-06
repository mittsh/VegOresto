//
//  NavigationAccueilViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 05/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MBProgressHUD

class NavigationAccueilViewController: UIViewController {

    @IBOutlet weak var varIB_scrollView: UIScrollView!

    @IBOutlet weak var varIB_button_tabbar_list: UIButton!
    @IBOutlet weak var varIB_button_tabbar_maps: UIButton!

    @IBOutlet weak var varIB_contrainte_y_chevron_tabbar: NSLayoutConstraint!

    var recherche_viewController: RechercheViewController?
    var maps_viewController: MapsViewController?

    let HAUTEUR_HEADER_BAR = CGFloat(50.0)
    let HAUTEUR_TABBAR = CGFloat(60.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = COLOR_ORANGE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.title = "Retour"
        self.navigationController?.navigationBar.isTranslucent = true

        self.varIB_button_tabbar_list?.layer.cornerRadius = 6
        self.varIB_button_tabbar_maps?.layer.cornerRadius = 6
        // Do any additional setup after loading the view.

        self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear
        self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15

        MBProgressHUD.showAdded(to: self.view, animated: true)

        self.updateData(forced: false) { (_) in

            MBProgressHUD.hide(for: self.view, animated: true)
        }

    }

    func updateData(forced: Bool, completion : (( Bool ) -> Void)? ) {

        UserData.sharedInstance.updateDatabaseIfNeeded(forced: forced) { (success) in

            if success {

                self.maps_viewController?.updateDataAfterDelay()
                self.recherche_viewController?.updateDataAfterDelay()

                WebRequestManager.shared.loadHoraires(success: {

                }, failure: { (_) in

                })
            }

            completion?(success)

        }

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.

    }

    override func viewWillDisappear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func touch_bt_tabbar(sender: UIButton) {

        if self.varIB_button_tabbar_maps == sender {

            let frame = CGRect( x : Device.WIDTH, y : 0, width : Device.WIDTH, height : Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            self.varIB_scrollView.scrollRectToVisible( frame, animated: true )

            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.75 - 15

            UIView.animate(withDuration: 0.2, animations: {

                self.varIB_button_tabbar_list.backgroundColor = UIColor.clear
                self.varIB_button_tabbar_maps.backgroundColor = UIColor.white.withAlphaComponent(0.3)

            })

        } else if self.varIB_button_tabbar_list == sender {

            let frame = CGRect(x : 0, y : 0, width : Device.WIDTH, height :Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            self.varIB_scrollView.scrollRectToVisible( frame, animated: true )

            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15

            UIView.animate(withDuration: 0.2, animations: {

                self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear
                self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)

            })

        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func touch_bt_location(sender: UIButton) {

        if let nc_maps = self.maps_viewController {

            nc_maps.update_region_for_user_location()

        }

        if let nc_recherche = self.recherche_viewController {

            nc_recherche.update_resultats_for_user_location()

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = segue.destination as? RechercheViewController {
            self.recherche_viewController = vc

        } else if let vc = segue.destination as? MapsViewController {
            self.maps_viewController = vc

        }

    }

}
