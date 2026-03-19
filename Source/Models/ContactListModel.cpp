#include "ContactListModel.h"

ContactListModel::ContactListModel(QObject *parent)
    : QAbstractListModel{parent}
{
    createSampleContacts();
}

void ContactListModel::createSampleContacts()
{
    QStringList firstNames = {"John",  "Jane",   "Alice", "Bob",      "Clara", "David", "Emma",
                              "Frank", "Grace",  "Henry", "Isabella", "Jack",  "Liam",  "Mia",
                              "Noah",  "Olivia", "Paul",  "Quinn",    "Ryan",  "Sophia"};

    QStringList lastNames = {"Doe",
                             "Smith",
                             "Johnson",
                             "Miller",
                             "Schmidt",
                             "Brown",
                             "Wilson",
                             "Taylor",
                             "Anderson",
                             "Thomas",
                             "Martin",
                             "White",
                             "Walker",
                             "Hall",
                             "Allen"};

    QStringList companies = {"Siemens",
                             "BMW",
                             "SAP",
                             "Amazon",
                             "Google",
                             "Microsoft",
                             "Tesla",
                             "Airbus",
                             "Spotify",
                             "Bosch"};

    QStringList jobTitles = {"Software Engineer",
                             "Qt/QML Developer",
                             "Backend Developer",
                             "Frontend Developer",
                             "DevOps Engineer",
                             "UI/UX Designer",
                             "Cloud Architect",
                             "Mobile Developer"};

    QStringList tagsPool = {"client",
                            "alumni",
                            "lead",
                            "friends",
                            "vendor",
                            "prospect",
                            "partner",
                            "work",
                            "family",
                            "colleague"};

    for (int i = 0; i < 20; ++i) {
        QString first = firstNames[i % firstNames.size()];
        QString last = lastNames[i % lastNames.size()];

        Contact c(first, last);

        c.setEmail(first.toLower() + "." + last.toLower() + "@example.com");
        c.setPhone(QString("+4915%1").arg(100000000 + i));
        c.setCompany(companies[i % companies.size()]);
        c.setJobTitle(jobTitles[i % jobTitles.size()]);
        c.setAddress(QString("%1 Main Street, City %2").arg(i + 1).arg(i % 5));
        c.setNotes("Generated contact");
        c.setIsFavorite(i % 3 == 0);

        // Assign 1–2 tags
        QStringList tags;
        tags.append(tagsPool[i % tagsPool.size()]);
        if (i % 2 == 0)
            tags.append(tagsPool[(i + 3) % tagsPool.size()]);
        c.setTags(tags);

        m_contacts.append(c);
    }
}

int ContactListModel::rowCount(const QModelIndex &parent) const
{
    // parent here refers to hierarchial structures. since we have flat list all
    // items are in the root level, so parent is invalid
    if (parent.isValid())
        return 0;
    return m_contacts.size();
}

QVariant ContactListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_contacts.size())
        return QVariant();

    const Contact &contact = m_contacts.at(index.row());

    switch (role) {
    case IdRole:
        return contact.id();
    case FirstNameRole:
        return contact.firstName();
    case LastNameRole:
        return contact.lastName();
    case FullNameRole:
        return contact.fullName();
    case EmailRole:
        return contact.email();
    case PhoneRole:
        return contact.phone();
    case CompanyRole:
        return contact.company();
    case JobTitleRole:
        return contact.jobTitle();
    case AddressRole:
        return contact.address();
    case NotesRole:
        return contact.notes();
    case AvatarUrlRole:
        return contact.avatarUrl();
    case TagsRole:
        return contact.tags();
    case IsFavoriteRole:
        return contact.isFavorite();
    case DateAddedRole:
        return contact.dateAdded();
    case DateModifiedRole:
        return contact.dateModified();
    case InitialsRole:
        return contact.initials();
    case AvatarColorIndexRole:
        return contact.avatarColorIndex();
    case AvatarColorRole: {
        static const QStringList colors = {"#16A34A",
                                           "#0EA5E9",
                                           "#8B5CF6",
                                           "#0D9488",
                                           "#EC4899",
                                           "#6366F1",
                                           "#F59E0B",
                                           "#EF4444",
                                           "#06B6D4",
                                           "#8B5CF6"};
        int index = contact.avatarColorIndex();
        return colors[index % colors.size()];
    }
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ContactListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "contactId";
    roles[FirstNameRole] = "firstName";
    roles[LastNameRole] = "lastName";
    roles[FullNameRole] = "fullName";
    roles[EmailRole] = "email";
    roles[PhoneRole] = "phone";
    roles[CompanyRole] = "company";
    roles[JobTitleRole] = "jobTitle";
    roles[AddressRole] = "address";
    roles[NotesRole] = "notes";
    roles[AvatarUrlRole] = "avatarUrl";
    roles[TagsRole] = "tags";
    roles[IsFavoriteRole] = "isFavorite";
    roles[DateAddedRole] = "dateAdded";
    roles[DateModifiedRole] = "dateModified";
    roles[ContactFrequencyRole] = "contactFrequency";
    roles[InitialsRole] = "initials";
    roles[AvatarColorIndexRole] = "avatarColorIndex";
    roles[AvatarColorRole] = "avatarColor";
    return roles;
}

bool ContactListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_contacts.size())
        return false;

    Contact &contact = m_contacts[index.row()];
    bool changed = false;

    switch (role) {
    case FirstNameRole:
        contact.setFirstName(value.toString());
        changed = true;
        break;
    case LastNameRole:
        contact.setLastName(value.toString());
        changed = true;
        break;
    case EmailRole:
        contact.setEmail(value.toString());
        changed = true;
        break;
    case PhoneRole:
        contact.setPhone(value.toString());
        changed = true;
        break;
    case CompanyRole:
        contact.setCompany(value.toString());
        changed = true;
        break;
    case JobTitleRole:
        contact.setJobTitle(value.toString());
        changed = true;
        break;
    case IsFavoriteRole:
        contact.setIsFavorite(value.toBool());
        changed = true;
        emit contactUpdated();
        break;
    default:
        return false;
    }

    if (changed) {
        contact.touch();
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}

Qt::ItemFlags ContactListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return QAbstractListModel::flags(index) | Qt::ItemIsEditable;
}

int ContactListModel::count() const
{
    return m_contacts.size();
}

int ContactListModel::favoritesCount() const
{
    int numFavorites{0};

    std::ranges::for_each(m_contacts, [&numFavorites](const Contact &contact) {
        if (contact.isFavorite())
            numFavorites++;
    });

    return numFavorites;
}

void ContactListModel::addContact(const Contact &contact)
{
    int newRow = m_contacts.size();

    beginInsertRows(QModelIndex(), newRow, newRow);
    m_contacts.append(contact);
    endInsertRows();

    emit contactAdded();
}

void ContactListModel::addContacts(const QVector<Contact> &contacts)
{
    if (contacts.isEmpty())
        return;

    int startRowIndex = m_contacts.size();
    int endRowIndex = startRowIndex + (contacts.size() - 1);

    beginInsertRows(QModelIndex(), startRowIndex, endRowIndex);
    m_contacts.append(contacts);
    endInsertRows();

    emit contactAdded();
}

void ContactListModel::addContact(const QString &firstName,
                                  const QString &lastName,
                                  const QString &email,
                                  const QString &phone)
{
    Contact contact(firstName, lastName);
    if (!email.isEmpty())
        contact.setEmail(email);
    if (!phone.isEmpty())
        contact.setPhone(phone);
    addContact(contact);
}

void ContactListModel::addContactFull(const QString &firstName,
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
    Contact contact(firstName, lastName);

    if (!email.isEmpty())
        contact.setEmail(email);
    if (!phone.isEmpty())
        contact.setPhone(phone);
    if (!company.isEmpty())
        contact.setCompany(company);
    if (!jobTitle.isEmpty())
        contact.setJobTitle(jobTitle);
    if (!address.isEmpty())
        contact.setAddress(address);
    if (!notes.isEmpty())
        contact.setNotes(notes);
    contact.setIsFavorite(isFavorite);
    contact.setTags(tags);

    addContact(contact);
}

void ContactListModel::updateContact(int index, const Contact &contact) {}

void ContactListModel::updateContact(int index,
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
    if (!isValidIndex(index))
        return;

    Contact &contact = m_contacts[index];

    contact.setFirstName(firstName);
    contact.setLastName(lastName);
    contact.setEmail(email);
    contact.setPhone(phone);
    contact.setCompany(company);
    contact.setJobTitle(jobTitle);
    contact.setAddress(address);
    contact.setNotes(notes);
    contact.setIsFavorite(isFavorite);
    contact.setTags(tags);

    QModelIndex rowIndex = createIndex(index, 0);

    emit dataChanged(rowIndex,
                     rowIndex,
                     {FirstNameRole,
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
                      AvatarColorRole});
}

void ContactListModel::removeContact(int index)
{
    if (!isValidIndex(index))
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_contacts.removeAt(index);
    endRemoveRows();

    emit contactRemoved();
}

void ContactListModel::clear()
{
    if (!m_contacts.empty()) {
        beginResetModel();
        m_contacts.clear();
        endResetModel();
    }

    emit contactRemoved();
}

QVector<Contact> ContactListModel::getAllContacts() const
{
    if (!m_contacts.empty()) {
        return m_contacts;
    }
    return {};
}

std::expected<Contact, QString> ContactListModel::getContact(int index) const
{
    return isValidIndex(index) ? std::expected<Contact, QString>{m_contacts[index]}
                               : std::unexpected(QStringLiteral("Invalid index"));
}

bool ContactListModel::isValidIndex(int index) const
{
    return (index >= 0 && index < m_contacts.size());
}
