//
//  StoresTunnelsInfo.swift
//  BaseVPN
//
//  Created by Lika Vorobeva on 13.10.2021.
//

import Foundation

protocol StoresTunnelsInfo {
    func set(dns: DNSServerType)
    var selectedDNS: DNSServerType { get }
}
