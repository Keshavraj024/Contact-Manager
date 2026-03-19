#pragma once

#include <QObject>
#include <QQmlEngine>
#include "ContactFilterProxyModel.h"
#include "ContactListModel.h"

class ContactManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(ContactListModel *contactModel READ contactModel CONSTANT)
    Q_PROPERTY(ContactFilterProxyModel *proxyModel READ proxyModel CONSTANT)
    Q_PROPERTY(int totalContacts READ totalContacts NOTIFY totalContactsChanged)
    Q_PROPERTY(int favoritesContacts READ favoritesCount NOTIFY favoritesCountChanged)

public:
    explicit ContactManager(QObject *parent = nullptr);

    Q_INVOKABLE void addContact(const QString &firstName,
                                const QString &lastName,
                                const QString &email = QString(),
                                const QString &phone = QString());
    Q_INVOKABLE void addContactFull(const QString &firstName,
                                    const QString &lastName,
                                    const QString &email,
                                    const QString &phone,
                                    const QString &company,
                                    const QString &jobTitle,
                                    const QString &address,
                                    const QString &notes,
                                    bool isFavorite,
                                    const QStringList &tags);
    Q_INVOKABLE void updateContactFull(int index,
                                       const QString &firstName,
                                       const QString &lastName,
                                       const QString &email,
                                       const QString &phone,
                                       const QString &company,
                                       const QString &jobTitle,
                                       const QString &address,
                                       const QString &notes,
                                       bool isFavorite,
                                       const QStringList &tags);

    Q_INVOKABLE void removeContact(int index);
    Q_INVOKABLE void toggleFavorite(int index);
    Q_INVOKABLE void clearAllContacts();
    Q_INVOKABLE QVariantMap getContact(int index);

    ContactListModel *contactModel() const;

    int totalContacts() const;
    int favoritesCount() const;

    ContactFilterProxyModel *proxyModel() const;

signals:
    void totalContactsChanged();
    void favoritesCountChanged();

private:
    ContactListModel *m_contactModel = nullptr;
    ContactFilterProxyModel *m_proxyModel = nullptr;
    int m_totalContacts;
    int m_favoritesCount;

private:
    void setupConnections();
};
