//
//  ProfileView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI

struct ProfileView: View {

    @StateObject var profileViewModel = ProfileViewModel()
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 20) {
                Spacer()
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
                Spacer()
        
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Name").foregroundColor(Color("PrimaryColor"))
                TextField("Enter Name", text: $profileViewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Phone Number").foregroundColor(Color("PrimaryColor"))
                TextField("Enter phone number", text: $profileViewModel.phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    
                
                Text("Email").foregroundColor(Color("PrimaryColor"))
                TextField("Enter email", text: $profileViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Address").foregroundColor(Color("PrimaryColor"))
                TextField("Enter address", text: $profileViewModel.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("City").foregroundColor(Color("PrimaryColor"))
                        TextField("Enter city", text: $profileViewModel.city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("State").foregroundColor(Color("PrimaryColor"))
                        TextField("Enter state", text: $profileViewModel.state)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Zip").foregroundColor(Color("PrimaryColor"))
                        TextField("Enter zip code", text: $profileViewModel.zip)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
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

