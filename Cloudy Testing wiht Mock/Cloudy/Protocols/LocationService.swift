//
//  LocationService.swift
//  Cloudy
//
//  Created by Bart Jacobs on 29/11/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

protocol LocationService {

    typealias LocationServiceCompletionHandler = ([Location], Error?) -> Void

    func geocode(addressString: String?, completionHandler: @escaping LocationServiceCompletionHandler)

}
