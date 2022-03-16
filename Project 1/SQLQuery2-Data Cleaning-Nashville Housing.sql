--Cleaning Data in SQL Queries

Select *
From Portfolio_Project.dbo.NashvilleHousing


--Standardize Data Format

Select SaleDate, convert(date,SaleDate)
From Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(date,SaleDate)


--Populate Property Address data

Select *
From Portfolio_Project.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

--isnull checks to see if parameter is 'NULL', if it is, it can populate with alternative parameter)

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project.dbo.NashvilleHousing a
Join Portfolio_Project.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress) --you can also put a string instead of b.PropertyAddress i.e. 'No Address')
From Portfolio_Project.dbo.NashvilleHousing a
Join Portfolio_Project.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Portfolio_Project.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select
Substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address --(-1 is used to remove the comma)
, Substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as Address

From Portfolio_Project.dbo.NashvilleHousing

--To create 2 new columns

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress))


Select *
From Portfolio_Project.dbo.NashvilleHousing


--Populate Owner Address data (You can use Substings for this alternatively)

Select OwnerAddress
From Portfolio_Project.dbo.NashvilleHousing

Select
Parsename(replace(OwnerAddress,',','.'),3)
,Parsename(replace(OwnerAddress,',','.'),2)
,Parsename(replace(OwnerAddress,',','.'),1)
From Portfolio_Project.dbo.NashvilleHousing

--Add columns and values

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(replace(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = Parsename(replace(OwnerAddress,',','.'),1)

Select *
From Portfolio_Project.dbo.NashvilleHousing


--Change Y and No in 'Sold as Vacant' field

Select distinct(SoldAsVacant), count(SoldAsVacant)
From Portfolio_Project.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant 
	   end
From Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant 
	   end


--Remove Duplicates

With RowNumCTE as(
Select *,
	Row_number() over(
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num

From Portfolio_Project.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete Unused Columns

Select *
From Portfolio_Project.dbo.NashvilleHousing

Alter table Portfolio_Project.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table Portfolio_Project.dbo.NashvilleHousing
Drop column SaleDate 

