//
//  AddMenuItemView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import SwiftUI

struct AddMenuItemView: View {
    // MenuItemsListViewModel is an observed object used to manage the list of menu items
    @ObservedObject var menuListViewModel : MenuItemsListViewModel

    // Binding variable to control whether to show the Add Item view or not
    @Binding var showAddItemView :Bool

    // State variables to store the name, description and price of the menu item being added
    @State var name: String = ""
    @State var description: String = ""
    @State var price: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                }
                HStack{
                    Spacer()
                    // Button to add the new menu item
                    Button(action: {
                        // Check if the price is a valid number
                        guard Double(price) != nil else { return }
                        Task {
                            do {
                                // Call the addMenuItem function in the MenuItemsListViewModel to add the new item
                                try await menuListViewModel.addMenuItem(name: name, price: Double(price) ?? 0.0, description: description)
                                print("Menu item added successfully")
                                // Close the Add Item view after the item has been added successfully
                                showAddItemView = false
                                // Execute some other code here if the function is completed
                            } catch {
                                print("Error adding menu item: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Add Menu Item")
                            .padding()
                            .background(Color("PrimaryColor"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    Spacer()
                }
            }
            // Set the title and text color of the navigation bar
            .navigationBarTitle("Add New Item").foregroundColor(Color("PrimaryColor"))
        }
    }
}
