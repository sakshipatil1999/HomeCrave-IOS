//
//  RProfileView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 06/05/23.
//

import SwiftUI

struct RProfileView: View {
    
    // Create a StateObject that initializes the viewModel
    @StateObject var profileViewModel = RProfileViewModel()
    
    // Create a State variable to toggle the ImagePicker sheet
    @State private var showImagePicker = false
    
    var body: some View {
      
        // Set up the UI using a VStack
        VStack(alignment: .leading, spacing: 20) {
            
            // Add a HStack to hold the profile image
            HStack(alignment: .top, spacing: 20) {
                
                // Add a Spacer to push the image to the right
                Spacer()
                
                // Use an if statement to display either the profile image or a default icon
                if let image = profileViewModel.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showImagePicker = true
                        }
                }
                
                // Add another Spacer to push the rest of the UI to the right
                Spacer()
                
            }
            
            // Add a VStack to hold the rest of the UI elements
            VStack(alignment: .leading, spacing: 10) {
                
                // Add a Text field for the restaurant name
                Text(" Restaurant Name").foregroundColor(Color("PrimaryColor"))
                TextField("Enter Name", text: $profileViewModel.restaurantName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Add a Text field for the owner name
                Text("Owner Name").foregroundColor(Color("PrimaryColor"))
                TextField("Enter owner Name", text: $profileViewModel.ownerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                // Add a Text field for the phone number
                Text("Phone Number").foregroundColor(Color("PrimaryColor"))
                TextField("Enter phone number", text: $profileViewModel.ownerPhoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                // Add a Text field for the address
                Text("Address").foregroundColor(Color("PrimaryColor"))
                TextField("Enter address", text: $profileViewModel.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Add a HStack to hold the city, state, and zip code Text fields
                HStack(spacing: 20) {
                    
                    // Add a VStack to hold the Text field for the city
                    VStack(alignment: .leading, spacing: 10) {
                        Text("City").foregroundColor(Color("PrimaryColor"))
                        TextField("Enter city", text: $profileViewModel.city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Add a VStack to hold the Text field for the state
                    VStack(alignment: .leading, spacing: 10) {
                        Text("State").foregroundColor(Color("PrimaryColor"))
                        TextField("Enter state", text: $profileViewModel.state)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Add a VStack to hold the Text field for the zip code
                    VStack(alignment: .leading, spacing: 10) {
                            Text("Zip").foregroundColor(Color("PrimaryColor"))
                            TextField("Enter zip code", text: $profileViewModel.zip)
                                .textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad)
                        }
                    }
                }
                .padding(.horizontal)
            HStack{
                Spacer()
            Button(action: {
                profileViewModel.updateProfile()
            }) {
                Text("Save Profile Data")
                    .padding()
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
           
                Spacer()
        }
                Spacer()
            }
        .padding()
        .navigationBarTitle("Profile")
        
        // Call the loadProfile method of the viewModel when the view appears
        .onAppear(perform: profileViewModel.loadProfile)
        .sheet(isPresented: $showImagePicker) {
        ImagePicker(image: $profileViewModel.profileImage)
        }
    }
    
}

struct RProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RProfileView()
    }
}
