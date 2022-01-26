Select
* from Covidcases.dbo.Nashvillehousing

--Standardize date Format
Select SaleDate, CONVERT(Date, SaleDate)
 from Covidcases.dbo.Nashvillehousing

Update Nashvillehousing
Set SaleDate = CONVERT(Date, SaleDate)

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
 From Covidcases.dbo.Nashvillehousing

 --Populate Property Address Date

 Select PropertyAddress
 From Covidcases.dbo.Nashvillehousing

 Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
 From Covidcases.dbo.Nashvillehousing a
 Join  Covidcases.dbo.Nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> a.[UniqueID ]
 Where a.propertyAddress is Null

 Update a
 SET PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
 From Covidcases.dbo.Nashvillehousing a
 Join  Covidcases.dbo.Nashvillehousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> a.[UniqueID ]
 Where a.propertyAddress is Null
  
  --Breaking Address into Individual Columns ( Address, City, State)

  Select PropertyAddress
  From Covidcases.dbo.Nashvillehousing

  Select
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address,
  From Covidcases.dbo.Nashvillehousing


  Alter Table Nashvillehousing
Add PropertySpiltAddress Nvarchar (255);

Update Nashvillehousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table Nashvillehousing
Add PropertySplitCity Nvarchar (255);

Update Nashvillehousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select
* from Covidcases.dbo.Nashvillehousing


Select OwnerAddress
from Covidcases.dbo.Nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress,',', ','), 3),
PARSENAME(REPLACE(OwnerAddress,',', ','), 2),
PARSENAME(REPLACE(OwnerAddress,',', ','), 1)
From Covidcases.dbo.Nashvillehousing

 Alter Table Nashvillehousing
Add OwnerSpiltAddress Nvarchar (255);

Update Nashvillehousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', ','), 3)

 Alter Table Nashvillehousing
Add OwnerSpiltCity Nvarchar (255);

Update Nashvillehousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', ','), 2)

Alter Table Nashvillehousing
Add OwnerSplitState Nvarchar (255);

Update Nashvillehousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', ','), 1)

Select * from Covidcases.dbo.Nashvillehousing

--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From Covidcases.dbo.Nashvillehousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'YES'
     When SoldAsVacant = 'N' THEN 'NO'
	 Else SoldAsVacant
	 End
From Covidcases.dbo.Nashvillehousing

Update Nashvillehousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'YES'
     When SoldAsVacant = 'N' THEN 'NO'
	 Else SoldAsVacant
	 End

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
Row_Number() Over (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by
			 UniqueID
			 ) row_num

From Covidcases.dbo.Nashvillehousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress


--Delete Unused Columns

Select *
From Covidcases.dbo.Nashvillehousing

Alter Table Covidcases.dbo.Nashvillehousing
Drop Column TaxDistrict, SaleDate