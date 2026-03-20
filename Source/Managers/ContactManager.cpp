#include "ContactManager.h"

ContactManager::ContactManager(QObject *parent)
    : QObject{parent}
    , m_contactModel(new ContactListModel(this))
{
    m_proxyModel = new ContactFilterProxyModel(this);

    if (m_contactModel) {
        m_proxyModel->setSourceModel(m_contactModel);
        m_proxyModel->setSortAscending(true);
        m_proxyModel->sort(0, Qt::AscendingOrder);
    }

    setupConnections();
}

void ContactManager::addContact(const QString &firstName,
                                const QString &lastName,
                                const QString &email,
                                const QString &phone)
{
    m_contactModel->addContact(firstName, lastName, email, phone);
}

void ContactManager::addContactFull(const QString &firstName,
                                    const QString &lastName,
                                    const QString &email,
                                    const QString &phone,
                                    const QString &company,
                                    const QString &jobTitle,
                                    const QString &address,
                                    const QString &notes,
                                    bool isFavorite,
                                    const QStringList &tags)
{
    m_contactModel->addContactFull(
        firstName, lastName, email, phone, company, jobTitle, address, notes, isFavorite, tags);
}

void ContactManager::updateContactFull(int index,
                                       const QString &firstName,
                                       const QString &lastName,
                                       const QString &email,
                                       const QString &phone,
                                       const QString &company,
                                       const QString &jobTitle,
                                       const QString &address,
                                       const QString &notes,
                                       bool isFavorite,
                                       const QStringList &tags)
{
    m_contactModel->updateContact(index,
                                  firstName,
                                  lastName,
                                  email,
                                  phone,
                                  company,
                                  jobTitle,
                                  address,
                                  notes,
                                  isFavorite,
                                  tags);
}

void ContactManager::removeContact(int index)
{
    m_contactModel->removeContact(index);
}

void ContactManager::toggleFavorite(int index) {}

void ContactManager::clearAllContacts()
{
    m_contactModel->clear();
}

QVariantMap ContactManager::getContact(int index)
{
    const auto result = m_contactModel->getContact(index);

    QVariantMap data{};

    if (result) {
        const auto &contact = result.value();
        data["firstName"] = contact.firstName();
        data["lastName"] = contact.lastName();
        data["fullName"] = contact.fullName();
        data["initials"] = contact.initials();
        data["email"] = contact.email();
        data["phone"] = contact.phone();
        data["company"] = contact.company();
        data["jobTitle"] = contact.jobTitle();
        data["address"] = contact.address();
        data["notes"] = contact.notes();
        data["isFavorite"] = contact.isFavorite();
        data["tags"] = contact.tags();
        data["avatarColor"] = m_contactModel
                                  ->data(m_contactModel->index(index),
                                         ContactListModel::AvatarColorRole)
                                  .toString();
    } else {
        qDebug() << result.error();
    }

    return data;
}

ContactListModel *ContactManager::contactModel() const
{
    return m_contactModel;
}

int ContactManager::totalContacts() const
{
    return m_contactModel->count();
}

int ContactManager::favoritesCount() const
{
    return m_contactModel->favoritesCount();
}

void ContactManager::setupConnections()
{
    connect(m_contactModel,
            &ContactListModel::contactAdded,
            this,
            &ContactManager::totalContactsChanged);

    connect(m_contactModel,
            &ContactListModel::contactRemoved,
            this,
            &ContactManager::totalContactsChanged);

    connect(m_contactModel,
            &ContactListModel::contactUpdated,
            this,
            &ContactManager::favoritesCountChanged);
}

ContactFilterProxyModel *ContactManager::proxyModel() const
{
    return m_proxyModel;
}
