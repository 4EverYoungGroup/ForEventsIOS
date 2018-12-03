//
//  ConfigureSearchTextField.swift
//  ForEvents
//
//  Created by luis gomez alonso on 02/12/2018.
//  Copyright © 2018 4Everyoung.group. All rights reserved.
//

import UIKit
import SearchTextField

func configureSearchTextField(textField: SearchTextField) {
    textField.startVisibleWithoutInteraction = false
    // Set a visual theme (SearchTextFieldTheme). By default it's the light theme
    textField.theme = SearchTextFieldTheme.darkTheme()
    
    // Modify current theme properties
    textField.theme.font = UIFont(name: "AvenirNext-Bold", size: 13)!
    textField.theme.bgColor = .black
    textField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    textField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
    textField.theme.cellHeight = 50
    
    // Set specific comparision options - Default: .caseInsensitive
    textField.comparisonOptions = [.caseInsensitive]
    
    // Handle item selection - Default behaviour: item title set to the text field
    textField.itemSelectionHandler = { filteredResults, itemPosition in
        // Just in case you need the item position
        let item = filteredResults[itemPosition]
        
        // Do whatever you want with the picked item
        textField.text = item.title
        textField.endEditing(true)
    }
    
    // Update data source when the user stops typing
    textField.userStoppedTypingHandler = {
        if let criteria = textField.text {
            if criteria.count > 2 {
                
                // Show loading indicator
                textField.showLoadingIndicator()
                
                citiesDownload(queryText: criteria, textField: textField)
            }
        }
        } as (() -> Void)
}

func citiesDownload(queryText: String, textField: SearchTextField) {
    let citiesInteractor: GetCitiesInteractor = GetCitiesInteractorNSURLSessionImpl()
    
    citiesInteractor.execute(queryText: queryText) { (cities: [City]?) in
        // OK
        if cities != nil {
            //Create array with cities name result
            var citiesNames: [String] = []
            Global.citiesSelected = []
            for city in cities! {
                citiesNames.append(city.city+"/"+city.province!)
                Global.citiesSelected?.append(city)
            }
            // Set new items to filter
            textField.filterStrings(citiesNames)
            
            // Stop loading indicator
            textField.stopLoadingIndicator()
        }
    }
}
