import QtQuick
import QtQuick.Controls

import ContactManager 1.0

ApplicationWindow {
    id: window
    visible: true

    width: 1200
    height: 800

    minimumWidth: 900
    minimumHeight: 600

    title: "Contact Manager"
    color: "#F9FAFB"

    ContactManager {
        id: contactManager
    }

    AddContactDialog {
        id: addContactDialog
        onContactAdded: function( firstName, lastName, email,
                                 phone, company, jobTitle, address,
                                 notes, isFavorite, tags) {
            contactManager.addContactFull(firstName, lastName, email,
                                          phone, company, jobTitle, address,
                                          notes, isFavorite, tags)

        }
    }

    DeleteConfirmationDialog {
        id: deleteConfirmationDialog
        onDeleteConfirmed: function(index) {
            contactManager.removeContact(index);
        }
    }

    EditContactDialog {
        id: editContactDialog

        onContactUpdated: function( index, firstName,  lastName,  email,
                                   phone,  company,  jobTitle,  address,
                                   notes,  isFavorite,  tags) {
            contactManager.updateContactFull(index, firstName,  lastName,  email,
                                             phone,  company,  jobTitle,  address,
                                             notes,  isFavorite,  tags)
        }
    }

    ViewContactDialog {
        id: viewContactDialog

        onEditRequested: function(contactIndex) {
            var contact = contactManager.getContact(contactIndex)
            editContactDialog.loadContact(contactIndex, contact)
            editContactDialog.open()
        }
    }

    ContactListPage {
        anchors.fill: parent

        property int sourceIndex: -1

        proxyModel: contactManager?.proxyModel ?? null
        totalContacts: contactManager?.totalContacts ?? 0
        favoritesContacts: contactManager?.favoritesContacts ?? 0


        onViewContact: function(index, modelData){
            console.log("Contact selected:", modelData.dataModel.firstName)
            sourceIndex = proxyModel.mapToSourceIndex(index)
            viewContactDialog.loadContact(sourceIndex, modelData.dataModel)
            viewContactDialog.open()
        }

        onAddContactRequested: {
            console.log("Add contact requested")
            addContactDialog.open()
        }

        onDeleteRequested: function(index, modelData) {
            sourceIndex = proxyModel.mapToSourceIndex(index)
            deleteConfirmationDialog.setContact(sourceIndex, modelData.dataModel)
            deleteConfirmationDialog.open()
        }

        onEditRequested: function(index, modelData) {
            sourceIndex = proxyModel.mapToSourceIndex(index)
            editContactDialog.loadContact(sourceIndex, modelData.dataModel)
            editContactDialog.open()
        }

    }
}
