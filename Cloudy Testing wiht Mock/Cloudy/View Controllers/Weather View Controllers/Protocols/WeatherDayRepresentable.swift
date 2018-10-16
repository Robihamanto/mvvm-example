//
//  WeatherDayRepresentable.swift
//  Cloudy
//
//  Created by Bart Jacobs on 17/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit

protocol WeatherDayRepresentable {

    var day: String { get }
    var date: String { get }
    var image: UIImage? { get }
    var windSpeed: String { get }
    var temperature: String { get }

}
