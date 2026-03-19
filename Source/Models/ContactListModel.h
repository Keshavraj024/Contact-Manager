#pragma once

#include <QAbstractListModel>
#include <QVector>
#include <expected>

#include "Contact.h"

class ContactListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ContactRoles {
        IdRole = Qt::UserRole + 1,
        FirstNameRole,
        LastNameRole,
        FullNameRole,
        EmailRole,
        PhoneRole,
        CompanyRole,
        JobTitleRole,
        AddressRole,
        NotesRole,
        AvatarUrlRole,
        TagsRole,
        IsFavoriteRole,
        DateAddedRole,
        DateModifiedRole,
        ContactFrequencyRole,
        InitialsRole,
        AvatarColorIndexRole,
        AvatarColorRole
    };

    explicit ContactListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt ::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    int count() const;
    int favoritesCount() const;

    void addContact(const Contact &contact);
    void addContacts(const QVector<Contact> &contacts);

    void addContact(const QString &firstName,
                    const QString &lastName,
                    const QString &email = QString(),
                    const QString &phone = QString());

    void addContactFull(const QString &firstName,
                        const QString &lastName,
                        const QString &email,
                        const QString &phone,
                        const QString &company,
                        const QString &jobTitle,
                        const QString &address,
                        const QString &notes,
                        bool isFavorite,
                        const QStringList &tags);

    void updateContact(int index, const Contact &contact);

    void updateContact(int index,
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

    void removeContact(int index);

    void clear();

    QVector<Contact> getAllContacts() const;

    std::expected<Contact, QString> getContact(int index) const;

    void createSampleContacts();

signals:
    void contactAdded();
    void contactRemoved();
    void contactUpdated();

private:
    QVector<Contact> m_contacts;

private:
    bool isValidIndex(int index) const;
};
