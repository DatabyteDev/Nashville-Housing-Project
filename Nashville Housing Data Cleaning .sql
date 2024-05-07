

select *
from PortfolioProject.dbo.NashvilleHousing



--Standardizing Date Format


alter table NashvilleHousing
alter column SaleDate date;



-- Populate Property Address Data


select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set a.PropertyAddress = isnull(a.propertyaddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address, City, State)

select propertyaddress 
from PortfolioProject..NashvilleHousing



select 
SUBSTRING(PropertyAddress, 1,charindex(',',PropertyAddress) -1) as address
,SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1, len(PropertyAddress)) as address

from PortfolioProject..NashvilleHousing




alter table NashvilleHousing
add PropertySplitAdress nvarchar(255);


update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1,charindex(',',PropertyAddress) -1)



alter table NashvilleHousing
add PropertySplitCity nvarchar(255);


update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1, len(PropertyAddress))



select OwnerAddress
from PortfolioProject..NashvilleHousing




select 
parsename(replace(OwnerAddress, ',','.' ),3)
, parsename(replace(OwnerAddress, ',','.' ),2)
, parsename(replace(OwnerAddress, ',','.' ),1)
from PortfolioProject..NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAdress nvarchar(255);


update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAdress = parsename(replace(OwnerAddress, ',','.' ),3)


alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);


update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.' ),2)


alter table NashvilleHousing
add OwnerSplitState nvarchar(255);


update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',','.' ),1)



-- Changing Y and N to Yes and No in 'SoldAsVacant' Column



select SoldAsVacant, Case when SoldAsVacant = 'Y' then 'Yes'
							when SoldAsVacant = 'N' then 'No'
							else SoldAsVacant
							End
from PortfolioProject..NashvilleHousing


update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
							when SoldAsVacant = 'N' then 'No'
							else SoldAsVacant
							End


select distinct(SoldAsVacant) , count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2



--Removing Duplicates


with RowNumCTE as (
select *, Row_Number() over(partition by ParcelID,
										 PropertyAddress,
										 SaleDate,
										 SalePrice,
										 LegalReference
										 order by UniqueID) Row_Num
from PortfolioProject.dbo.NashvilleHousing
)
delete
from RowNumCTE
where Row_Num > 1
--order by [UniqueID ]



--Deleting Unused Columns


select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column PropertyAddress, OwnerAddress


















