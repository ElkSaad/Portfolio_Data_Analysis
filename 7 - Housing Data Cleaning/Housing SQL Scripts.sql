/*
Cleaning Data in SQL Queries
*/


Select *
From [Housing Data Cleaning].dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Standardize Date Format

ALTER TABLE NashvilleHousing
Add SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Housing Data Cleaning].dbo.NashvilleHousing


 --------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data

Select *
From [Housing Data Cleaning].dbo.NashvilleHousing
--Where PropertyAddress is null 
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress)
From [Housing Data Cleaning].dbo.NashvilleHousing as a
JOIN [Housing Data Cleaning].dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
From [Housing Data Cleaning].dbo.NashvilleHousing as a
JOIN [Housing Data Cleaning].dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Housing Data Cleaning].dbo.NashvilleHousing
--Where PropertyAddress is null 
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From [Housing Data Cleaning].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add Property_Address nvarchar(255);

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add Property_City nvarchar(255);

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select OwnerAddress
From [Housing Data Cleaning].dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Housing Data Cleaning].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add Owner_Address nvarchar(255);

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add Owner_City nvarchar(255);

UPDATE NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add Owner_State nvarchar(255);

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From [Housing Data Cleaning].dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From [Housing Data Cleaning].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Housing Data Cleaning].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


---------------------------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Housing Data Cleaning].dbo.NashvilleHousing
--order by ParcelID
)
DELETE 
From RowNumCTE
Where row_num > 1

Select *
From [Housing Data Cleaning].dbo.NashvilleHousing
