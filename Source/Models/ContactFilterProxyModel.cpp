#include "ContactFilterProxyModel.h"
#include "ContactListModel.h"

ContactFilterProxyModel::ContactFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
    , m_favoritesOnly(false)
    , m_sortAscending(true)
{
    setDynamicSortFilter(true);
    // Connect to rowCount changes for count property
    connect(this, &QAbstractItemModel::rowsInserted, this, &ContactFilterProxyModel ::countChanged);
    connect(this, &QAbstractItemModel::rowsRemoved, this, &ContactFilterProxyModel ::countChanged);
    connect(this, &QAbstractItemModel::modelReset, this, &ContactFilterProxyModel ::countChanged);
    connect(this, &QAbstractItemModel::layoutChanged, this, &ContactFilterProxyModel ::countChanged);
}

void ContactFilterProxyModel::setFavoritesOnly(bool favoritesOnly)
{
    if (m_favoritesOnly == favoritesOnly)
        return;
    m_favoritesOnly = favoritesOnly;
    beginFilterChange();
    endFilterChange();
    emit favoritesOnlyChanged();
    emit countChanged();
}
void ContactFilterProxyModel::setSearchText(const QString &searchText)
{
    if (m_searchText == searchText)
        return;
    m_searchText = searchText;
    beginFilterChange();
    endFilterChange();
    emit searchTextChanged();
    emit countChanged();
}
void ContactFilterProxyModel::setSelectedTags(const QStringList &selectedTags)
{
    if (m_selectedTags == selectedTags)
        return;
    m_selectedTags = selectedTags;
    beginFilterChange();
    endFilterChange();
    emit selectedTagsChanged();
    emit countChanged();
}

void ContactFilterProxyModel::setSortAscending(bool ascending)
{
    if (m_sortAscending == ascending)
        return;
    m_sortAscending = ascending;
    sort(0, ascending ? Qt::AscendingOrder : Qt::DescendingOrder);
    emit sortAscendingChanged();
}

int ContactFilterProxyModel::mapToSourceIndex(int proxyIndex) const
{
    QModelIndex proxyIdx = index(proxyIndex, 0);
    QModelIndex sourceIdx = mapToSource(proxyIdx);
    return sourceIdx.row();
}

bool ContactFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    // Check favorites filter
    if (!matchesFavorites(sourceRow, sourceParent))
        return false;
    // Check search text filter
    if (!matchesSearchText(sourceRow, sourceParent))
        return false;
    // Check tags filter
    if (!matchesTags(sourceRow, sourceParent))
        return false;

    return true;
}

bool ContactFilterProxyModel::matchesFavorites(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_favoritesOnly)
        return true;
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    return sourceModel()->data(index, ContactListModel::IsFavoriteRole).toBool();
}

bool ContactFilterProxyModel::matchesSearchText(int sourceRow, const QModelIndex &sourceParent) const
{
    if (m_searchText.isEmpty())
        return true;
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QString searchText = m_searchText.trimmed();
    auto *model = sourceModel();

    auto matches = [&](int role) {
        return model->data(index, role).toString().contains(searchText, Qt::CaseInsensitive);
    };

    return matches(ContactListModel::FirstNameRole) || matches(ContactListModel::LastNameRole)
           || matches(ContactListModel::FullNameRole) || matches(ContactListModel::EmailRole)
           || matches(ContactListModel::PhoneRole);
}

bool ContactFilterProxyModel::matchesTags(int sourceRow, const QModelIndex &sourceParent) const
{
    if (m_selectedTags.isEmpty())
        return true;

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QStringList contactTags = sourceModel()->data(index, ContactListModel::TagsRole).toStringList();

    return std::ranges::any_of(contactTags, [&](const QString &tag) {
        return std::ranges::contains(m_selectedTags, tag);
    });
}

bool ContactFilterProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QVariant leftData = sourceModel()->data(left, ContactListModel::FullNameRole);
    QVariant rightData = sourceModel()->data(right, ContactListModel::FullNameRole);
    return leftData.toString().toLower() < rightData.toString().toLower();
}
