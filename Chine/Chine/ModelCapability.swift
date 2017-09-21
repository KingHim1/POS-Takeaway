//
//  ModelCapability.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

enum ModelIndex: Int {     // Don't insert(Only addition)
    case none = 0
    case mpop
    case fvp10
    case tsp100
    case tsp650II
    case tsp700II
    case tsp800II
    case sm_S210I
    case sm_S220I
    case sm_S230I
    case sm_T300I
    case sm_T400I
    case bsc10
    case sm_S210I_StarPRNT
    case sm_S220I_StarPRNT
    case sm_S230I_StarPRNT
    case sm_T300I_StarPRNT
    case sm_T400I_StarPRNT
    case sm_L200
    case sp700
    
    // V5.3.0
    case sm_L300
}

class ModelCapability : NSObject {
    enum ModelCapabilityIndex: Int {
        case title = 0
        case emulation
        case cashDrawerOpenActive
        case portSettings
        case modelNameArray
    }
    
    static let modelIndexArray: [ModelIndex] = [
        ModelIndex.mpop,
        ModelIndex.fvp10,
        ModelIndex.tsp100,
        ModelIndex.tsp650II,
        ModelIndex.tsp700II,
        ModelIndex.tsp800II,
        ModelIndex.sp700,                 // <-
        ModelIndex.sm_S210I,
        ModelIndex.sm_S220I,
        ModelIndex.sm_S230I,
        ModelIndex.sm_T300I,
        ModelIndex.sm_T400I,
        ModelIndex.sm_L200,               // <-
        ModelIndex.sm_L300,               // <-
        ModelIndex.bsc10,
        ModelIndex.sm_S210I_StarPRNT,
        ModelIndex.sm_S220I_StarPRNT,
        ModelIndex.sm_S230I_StarPRNT,
        ModelIndex.sm_T300I_StarPRNT,
        ModelIndex.sm_T400I_StarPRNT
//      ModelIndex.sm_L200,
//      ModelIndex.sp700,
//      ModelIndex.sm_L300
    ]
    
    static var modelCapabilityDictionary: [ModelIndex: [Any]] = [
        ModelIndex.mpop              : ["mPOP",              StarIoExtEmulation.starPRNT     .rawValue, false, "",         ["POP10"]],
        ModelIndex.fvp10             : ["FVP10",             StarIoExtEmulation.starLine     .rawValue, true,  "",         ["FVP10 (STR_T-001)"]],      // Only LAN model
        ModelIndex.tsp100            : ["TSP100",            StarIoExtEmulation.starGraphic  .rawValue, true,  "",         ["TSP113",
                                                                                                                            "TSP143"]],
        ModelIndex.tsp650II          : ["TSP650II",          StarIoExtEmulation.starLine     .rawValue, true,  "",         ["TSP654II (STR_T-001)",     // Only LAN model->
                                                                                                                            "TSP654 (STR_T-001)",
                                                                                                                            "TSP651 (STR_T-001)"]],
        ModelIndex.tsp700II          : ["TSP700II",          StarIoExtEmulation.starLine     .rawValue, true,  "",         ["TSP743II (STR_T-001)",
                                                                                                                            "TSP743 (STR_T-001)"]],
        ModelIndex.tsp800II          : ["TSP800II",          StarIoExtEmulation.starLine     .rawValue, true,  "",         ["TSP847II (STR_T-001)",
                                                                                                                            "TSP847 (STR_T-001)"]],     // <-Only LAN model
        ModelIndex.sm_S210I          : ["SM-S210i",          StarIoExtEmulation.escPosMobile .rawValue, false, "mini",     ["SM-S210i"]],               // Sample->
        ModelIndex.sm_S220I          : ["SM-S220i",          StarIoExtEmulation.escPosMobile .rawValue, false, "mini",     ["SM-S220i"]],
        ModelIndex.sm_S230I          : ["SM-S230i",          StarIoExtEmulation.escPosMobile .rawValue, false, "mini",     ["SM-S230i"]],
        ModelIndex.sm_T300I          : ["SM-T300i",          StarIoExtEmulation.escPosMobile .rawValue, false, "mini",     ["SM-T300i"]],
        ModelIndex.sm_T400I          : ["SM-T400i",          StarIoExtEmulation.escPosMobile .rawValue, false, "mini",     ["SM-T400i"]],               // <-Sample
        ModelIndex.bsc10             : ["BSC10",             StarIoExtEmulation.escPos       .rawValue, true,  "escpos",   ["BSC10"]],
        ModelIndex.sm_S210I_StarPRNT : ["SM-S210i StarPRNT", StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-S210i StarPRNT"]],      // Sample->
        ModelIndex.sm_S220I_StarPRNT : ["SM-S220i StarPRNT", StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-S220i StarPRNT"]],
        ModelIndex.sm_S230I_StarPRNT : ["SM-S230i StarPRNT", StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-S230i StarPRNT"]],
        ModelIndex.sm_T300I_StarPRNT : ["SM-T300i StarPRNT", StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-T300i StarPRNT"]],
        ModelIndex.sm_T400I_StarPRNT : ["SM-T400i StarPRNT", StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-T400i StarPRNT"]],      // <-Sample
        ModelIndex.sm_L200           : ["SM-L200",           StarIoExtEmulation.starPRNT     .rawValue, false, "Portable", ["SM-L200"]],
        ModelIndex.sp700             : ["SP700",             StarIoExtEmulation.starDotImpact.rawValue, true,  "",         ["SP712 (STR-001)",          // Only LAN model
                                                                                                                            "SP717 (STR-001)",
                                                                                                                            "SP742 (STR-001)",
                                                                                                                            "SP747 (STR-001)"]],
        ModelIndex.sm_L300           : ["SM-L300",           StarIoExtEmulation.starPRNTL    .rawValue, false, "Portable", ["SM-L300"]]
    ]
    
    static func modelIndexCount() -> Int {
        return ModelCapability.modelIndexArray.count
    }
    
    static func modelIndexAtIndex(_ index: Int) -> ModelIndex {
        return ModelCapability.modelIndexArray[index]
    }
    
    static func titleAtModelIndex(_ modelIndex: ModelIndex) -> String! {
        return ModelCapability.modelCapabilityDictionary[modelIndex]![ModelCapabilityIndex.title.rawValue] as! String
    }
    
    static func emulationAtModelIndex(_ modelIndex: ModelIndex) -> StarIoExtEmulation {
        return StarIoExtEmulation(rawValue: ModelCapability.modelCapabilityDictionary[modelIndex]![ModelCapabilityIndex.emulation.rawValue] as! Int)!
    }
    
    static func cashDrawerOpenActiveAtModelIndex(_ modelIndex: ModelIndex) -> Bool {
        return ModelCapability.modelCapabilityDictionary[modelIndex]![ModelCapabilityIndex.cashDrawerOpenActive.rawValue] as! Bool
    }
    
    static func portSettingsAtModelIndex(_ modelIndex: ModelIndex) -> String! {
        return ModelCapability.modelCapabilityDictionary[modelIndex]![ModelCapabilityIndex.portSettings.rawValue] as! String
    }
    
    static func modelIndexAtModelName(_ modelName: String!) -> ModelIndex {
        for (modelIndex, anyObject) in ModelCapability.modelCapabilityDictionary {
            let modelNameArray: [String] = anyObject[ModelCapabilityIndex.modelNameArray.rawValue] as! [String]
            
            for i: Int in 0 ..< modelNameArray.count {
                if modelName.hasPrefix(modelNameArray[i]) == true {
                    return modelIndex
                }
            }
        }
        
        return ModelIndex.none
    }
}
