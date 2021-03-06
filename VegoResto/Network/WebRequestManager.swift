//
//  ContractManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation

class WebRequestManager {

    static let shared = WebRequestManager()

    func listComment(  restaurant: Restaurant?,
                       success: @escaping ([Comment]) -> Void,
                       failure: @escaping (Error?) -> Void) {

        let urlPath = URL_SERVEUR() + "/wp-json/wp/v2/comments?post=" + String(restaurant?.identifier?.intValue ?? 0)

        WebRequestServices.listComment(urlPath: urlPath, success: { (listComment) in

            restaurant?.comments = nil

            for comment: Comment in restaurant?.getCommentsAsArray() ?? [] {

                UserData.sharedInstance.managedContext.delete(comment)

            }

            restaurant?.comments = NSSet()

            for comment in listComment as [Comment] {

                restaurant?.addComment(newComment: comment)
            }

            success(listComment)

        }) { (error) in

            failure(error)

        }

    }

    func listRestaurant(  success: @escaping ([Restaurant]) -> Void,
                          failure: @escaping (Error?) -> Void) {

        WebRequestServices.listRestaurant(urlPath: URL_SERVEUR() +  "/wp-json/vg/v1/restos.json", success: { (listRestaurants) in

            success(listRestaurants)

        }, failure: failure)

    }

 func postImageMedia( image: UIImage,
                      success: @escaping (String) -> Void,
                      failure: @escaping (Error?) -> Void ) {

    WebRequestServices.postImageMedia(urlPath: URL_SERVEUR() + "/wp-json/vegoresto/v1/media", image: image, success: { (identImageResult) in

        success(identImageResult)

    }, failure: failure)

    }

    func loadHoraires(  success: @escaping () -> Void,
                        failure: @escaping (Error?) -> Void) {

        WebRequestServices.loadHoraires(urlPath: URL_SERVEUR() + "/wp-content/cache/horaires.json", success: { (_) in

            success()

        }, failure: failure)

    }

    func uploadComment(restaurant: Restaurant, comment: Comment,
                              success: @escaping (Comment) -> Void,
                              failure: @escaping (Error?) -> Void) {

        WebRequestServices.uploadComment(urlPath: URL_SERVEUR() + "/wp-json/vegoresto/v1/comments", restaurant: restaurant, comment: comment, success: { (resultComment) in

            success(resultComment)

        }) { (error) in

            failure(error)

        }

    }

}
