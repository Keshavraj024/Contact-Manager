#pragma once

#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>
#include <QString>
#include <QUrl>

class Contact
{
public:
    Contact();
    Contact(const QString &firstName, const QString &lastName);

    QString id() const;
    void setId(const QString &newId);

    QString firstName() const;
    void setFirstName(const QString &newFirstName);

    QString lastName() const;
    void setLastName(const QString &newLastName);

    QString email() const;
    void setEmail(const QString &newEmail);

    QString phone() const;
    void setPhone(const QString &newPhone);

    QString company() const;
    void setCompany(const QString &newCompany);

    QString jobTitle() const;
    void setJobTitle(const QString &newJobTitle);

    QString address() const;
    void setAddress(const QString &newAddress);

    QString notes() const;
    void setNotes(const QString &newNotes);

    QUrl avatarUrl() const;
    void setAvatarUrl(const QUrl &newAvatarUrl);

    QStringList tags() const;
    void setTags(const QStringList &newTags);

    bool isFavorite() const;
    void setIsFavorite(bool newIsFavorite);

    QDateTime dateAdded() const;
    void setDateAdded(const QDateTime &newDateAdded);

    QDateTime dateModified() const;
    void setDateModified(const QDateTime &newDateModified);

    int contactFrequency() const;
    void setContactFrequency(int newContactFrequency);

    QString fullName() const;

    // UTILITY METHODS
    void addTag(const QString &tag);
    void removeTag(const QString &tag);
    bool hasTag(const QString &tag) const;

    QJsonObject toJson() const;
    static Contact fromJson(const QJsonObject &json);

    bool operator==(const Contact &other) const;
    bool operator!=(const Contact &other) const;

    QString initials() const;
    int avatarColorIndex() const;

    void touch();

private:
    QString m_id;
    QString m_firstName;
    QString m_lastName;
    QString m_email;
    QString m_phone;
    QString m_company;
    QString m_jobTitle;
    QString m_address;
    QString m_notes;
    QUrl m_avatarUrl;
    QStringList m_tags;
    bool m_isFavorite;
    QDateTime m_dateAdded;
    QDateTime m_dateModified;
    int m_contactFrequency;

private:
};
