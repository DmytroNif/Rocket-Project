//
//  AddNoteView.swift
//  Rocket-Project
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddNoteViewModel()

    /// Called after a note is stored successfully, before the sheet dismisses.
    var onSaved: () -> Void = {}

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        String(localized: "E.g. morning run, commute, walk in the park"),
                        text: $viewModel.text,
                        axis: .vertical
                    )
                    .lineLimit(3 ... 8)
                } header: {
                    Text(String(localized: "What are you up to?"))
                }
            }
            .navigationTitle(String(localized: "New note"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isLoading {
                        ProgressView()
                            .accessibilityLabel(String(localized: "Loading weather…"))
                    } else {
                        Button(String(localized: "Save")) {
                            Task {
                                if await viewModel.save() {
                                    onSaved()
                                    dismiss()
                                }
                            }
                        }
                        .disabled(!viewModel.canSave)
                    }
                }
            }
            .alert(
                String(localized: "Could not save"),
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button(String(localized: "OK"), role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                if let m = viewModel.errorMessage { Text(m) }
            }
        }
    }
}

#Preview {
    AddNoteView()
}
