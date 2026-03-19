#include "Contact.h"
#include <QUuid>

Contact::Contact()
    : m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_isFavorite(false)
    , m_dateAdded(QDateTime::currentDateTime())
    , m_dateModified(QDateTime::currentDateTime())
{}

Contact::Contact(const QString &firstName, const QString &lastName)
    : m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_firstName(firstName)
    , m_lastName(lastName)
    , m_isFavorite(false)
    , m_dateAdded(QDateTime::currentDateTime())
    , m_dateModified(QDateTime::currentDateTime())
{}

QString Contact::id() const
{
    return m_id;
}

void Contact::setId(const QString &newId)
{
    m_id = newId;
}

QString Contact::firstName() const
{
    return m_firstName;
}

void Contact::setFirstName(const QString &newFirstName)
{
    if (m_firstName == newFirstName)
        return;
    m_firstName = newFirstName;
    touch();
}

QString Contact::lastName() const
{
    return m_lastName;
}

void Contact::setLastName(const QString &newLastName)
{
    if (m_lastName == newLastName)
        return;

    m_lastName = newLastName;
    touch();
}

QString Contact::email() const
{
    return m_email;
}

void Contact::setEmail(const QString &newEmail)
{
    if (m_email == newEmail)
        return;

    m_email = newEmail;
    touch();
}

QString Contact::phone() const
{
    return m_phone;
}

void Contact::setPhone(const QString &newPhone)
{
    if (m_phone == newPhone)
        return;

    m_phone = newPhone;
    touch();
}

QString Contact::company() const
{
    return m_company;
}

void Contact::setCompany(const QString &newCompany)
{
    if (m_company == newCompany)
        return;

    m_company = newCompany;
    touch();
}

QString Contact::jobTitle() const
{
    return m_jobTitle;
}

void Contact::setJobTitle(const QString &newJobTitle)
{
    if (m_jobTitle == newJobTitle)
        return;

    m_jobTitle = newJobTitle;
    touch();
}

QString Contact::address() const
{
    return m_address;
}

void Contact::setAddress(const QString &newAddress)
{
    if (m_address == newAddress)
        return;

    m_address = newAddress;
    touch();
}

QString Contact::notes() const
{
    return m_notes;
}

void Contact::setNotes(const QString &newNotes)
{
    if (m_notes == newNotes)
        return;

    m_notes = newNotes;
    touch();
}

QUrl Contact::avatarUrl() const
{
    return m_avatarUrl;
}

void Contact::setAvatarUrl(const QUrl &newAvatarUrl)
{
    if (m_avatarUrl == newAvatarUrl)
        return;

    m_avatarUrl = newAvatarUrl;
    touch();
}

QStringList Contact::tags() const
{
    return m_tags;
}

void Contact::setTags(const QStringList &newTags)
{
    if (m_tags == newTags)
        return;

    m_tags = newTags;
    touch();
}

bool Contact::isFavorite() const
{
    return m_isFavorite;
}

void Contact::setIsFavorite(bool newIsFavorite)
{
    if (m_isFavorite == newIsFavorite)
        return;

    m_isFavorite = newIsFavorite;
    touch();
}

int Contact::contactFrequency() const
{
    return m_contactFrequency;
}

void Contact::setContactFrequency(int newContactFrequency)
{
    if (m_contactFrequency == newContactFrequency)
        return;
    m_contactFrequency = newContactFrequency;
    touch();
}

QString Contact::fullName() const
{
    QString fullName{""};
    if (!m_firstName.isEmpty() && !m_lastName.isEmpty())
        fullName = m_firstName + " " + m_lastName;
    return fullName;
}

void Contact::addTag(const QString &tag)
{
    if (!hasTag(tag)) {
        m_tags.append(tag);
        touch();
    }
}

void Contact::removeTag(const QString &tag)
{
    if (hasTag(tag) && m_tags.removeOne(tag)) {
        touch();
    }
}

bool Contact::hasTag(const QString &tag) const
{
    return m_tags.contains(tag);
}

QJsonObject Contact::toJson() const
{
    QJsonObject jsonObj;

    jsonObj["id"] = m_id;
    jsonObj["firstName"] = m_firstName;
    jsonObj["lastName"] = m_lastName;
    jsonObj["email"] = m_email;
    jsonObj["phone"] = m_phone;
    jsonObj["company"] = m_company;
    jsonObj["jobTitle"] = m_jobTitle;
    jsonObj["address"] = m_address;
    jsonObj["notes"] = m_notes;
    jsonObj["avatarUrl"] = m_avatarUrl.toString();

    QJsonArray tagsArray;
    for (const QString &tag : m_tags) {
        tagsArray.append(tag);
    }
    jsonObj["tags"] = tagsArray;

    jsonObj["isFavorite"] = m_isFavorite;
    jsonObj["dateAdded"] = m_dateAdded.toString(Qt::ISODate);
    jsonObj["dateModified"] = m_dateModified.toString(Qt::ISODate);

    return jsonObj;
}

Contact Contact::fromJson(const QJsonObject &json)
{
    Contact contact;

    contact.m_id = json["id"].toString();
    contact.m_firstName = json["firstName"].toString();
    contact.m_lastName = json["lastName"].toString();
    contact.m_email = json["email"].toString();
    contact.m_phone = json["phone"].toString();
    contact.m_company = json["company"].toString();
    contact.m_jobTitle = json["jobTitle"].toString();
    contact.m_address = json["address"].toString();
    contact.m_notes = json["notes"].toString();
    contact.m_avatarUrl = QUrl(json["avatarUrl"].toString());

    QJsonArray tagsArray = json["tags"].toArray();
    QStringList tags;
    foreach (const QJsonValue &value, tagsArray) {
        tags.append(value.toString());
    }
    contact.m_tags = tags;

    contact.m_isFavorite = json["isFavorite"].toBool();
    contact.m_dateAdded = QDateTime::fromString(json["dateAdded"].toString(), Qt ::ISODate);
    contact.m_dateModified = QDateTime::fromString(json["dateModified"].toString(), Qt::ISODate);

    return contact;
}

bool Contact::operator==(const Contact &other) const
{
    return m_id == other.m_id;
}

QString Contact::initials() const
{
    QString result;
    if (!m_firstName.isEmpty()) {
        result += m_firstName.front().toUpper();
    }
    if (!m_lastName.isEmpty()) {
        result += m_lastName.front().toUpper();
    }
    return result.isEmpty() ? QStringLiteral("?") : result;
}

int Contact::avatarColorIndex() const
{
    QString name = fullName();
    if (name.isEmpty())
        name = m_id;
    uint hash = qHash(name);
    return static_cast<int>(hash % 8);
}

QDateTime Contact::dateAdded() const
{
    return m_dateAdded;
}

void Contact::setDateAdded(const QDateTime &newDateAdded)
{
    m_dateAdded = newDateAdded;
}

QDateTime Contact::dateModified() const
{
    return m_dateModified;
}

void Contact::setDateModified(const QDateTime &newDateModified)
{
    m_dateModified = newDateModified;
}

void Contact::touch()
{
    m_dateModified = QDateTime::currentDateTime();
}
