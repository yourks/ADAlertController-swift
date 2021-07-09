//
//  ADFunctionModel.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/24.
//

import UIKit

class ADFunctionModel: ADBaseModel {
    var title: String?
    
    var selector: String?
    
    func getData(_ title: String , _ selector: String) -> ADFunctionModel {
        
        let functionModel = ADFunctionModel()
        
        functionModel.title = title;
        
        functionModel.selector = selector;
        
        return functionModel
    }

}

