//
//  MenuView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 5/3/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
struct MenuView: View {
    
    // state object for menu items list view model
    @StateObject private var menuItemListViewModel : MenuItemsListViewModel
    // state variable to control showing add item view
    @State var showAddItemView = false
    // restaurant ID of the authenticated user
    @State var restaurantId = Auth.auth().currentUser?.uid
    
    // initializer with restaurant ID parameter
    init(restaurantId: String) {
        // initialize menu items list view model with restaurant ID
        self._menuItemListViewModel = StateObject(wrappedValue: MenuItemsListViewModel(restaurantId: restaurantId))
    }
    
    var body: some View {
        // main view with a list of menu items and an add item button
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(menuItemListViewModel.menuItems) { item in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.headline)
                    }
                }
                // allow deleting menu items
                .onDelete(perform: deleteMenuItem)
            }
            // navigation bar title
            .navigationBarTitle("Menu")
            
            // add item button
            Button(action: {
                self.showAddItemView.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(Color("PrimaryColor"))
                    .frame(width: 60, height: 60)
                    .padding()
            }
            // add item sheet view
            .sheet(isPresented: $showAddItemView, content: {
                AddMenuItemView(menuListViewModel:menuItemListViewModel,showAddItemView: $showAddItemView)
            })
        }
    }
    
    // function to delete a menu item at given index set
    func deleteMenuItem(at offsets: IndexSet) {
        menuItemListViewModel.menuItems.remove(atOffsets: offsets)
    }
}

