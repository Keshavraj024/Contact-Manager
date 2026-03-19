cmake_minimum_required(VERSION 3.16)

project(ContactManager VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 23)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

set(PROJECT_SOURCES
    main.cpp
    Source/Models/Contact.h Source/Models/Contact.cpp
    Source/AudioRecorder.h Source/AudioRecorder.cpp
    Source/Models/ContactListModel.h Source/Models/ContactListModel.cpp
    Source/Managers/ContactManager.h Source/Managers/ContactManager.cpp
)

set(QML_SOURCE_FILES
    Qml/Main.qml

    Qml/Pages/ContactListPage.qml

    Qml/Components/ContactDelegate.qml
    Qml/Components/SearchBar.qml
    Qml/Components/FilterPanel.qml
    Qml/Components/AddContactDialog.qml
    Qml/Components/DeleteConfirmationDialog.qml
    Qml/Components/ViewContactDialog.qml

    Qml/Customs/Divider.qml
    Qml/Customs/CustomButton.qml
    Qml/Customs/CustomTextField.qml
    Qml/Customs/CustomTextArea.qml
)

set(PROJECT_RESOURCES
    Assets/contactAppImage.png
    Assets/BookCover.png
)

qt_add_executable(ContactManager
    ${PROJECT_SOURCES}
)

qt_add_qml_module(ContactManager
    URI ContactManager
    VERSION 1.0
    QML_FILES ${QML_SOURCE_FILES}
    RESOURCES ${PROJECT_RESOURCES}
    QML_FILES Qml/Components/EditContactDialog.qml
    SOURCES Source/Models/ContactFilterProxyModel.h Source/Models/ContactFilterProxyModel.cpp
)

target_include_directories(ContactManager PRIVATE Source/Models Source/Managers Source/)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(ContactManager PROPERTIES
    #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.ContactManager
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(ContactManager
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS ContactManager
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
