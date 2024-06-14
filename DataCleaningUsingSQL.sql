/*

Cleaning Data in SQL Queries

*/


Select * 
from NewPortfolio..['HousingData']


-- Standardize Date Format




SELECT SaleDate, CONVERT(Date, SaleDate)
from NewPortfolio..['HousingData']
 
Alter table NewPortfolio..['HousingData']
ALTER COLUMN SaleDate Date



-- Populate Property Address data



Select PropertyAddress, ParcelID
from NewPortfolio..['HousingData']
Where PropertyAddress is null
Order by ParcelID

SELECT 
    table_a.ParcelID, table_a.PropertyAddress, 
    table_b.ParcelID, table_b.PropertyAddress,
    ISNULL(table_a.PropertyAddress,table_b.PropertyAddress) AS to_populate
FROM NewPortfolio..['HousingData'] table_a
JOIN NewPortfolio..['HousingData'] table_b
    ON table_a.ParcelID = table_b.ParcelID
    AND table_a.UniqueID <> table_b.UniqueID
WHERE table_a.PropertyAddress IS NULL

UPDATE table_a 
SET [PropertyAddress] = ISNULL(table_a.[PropertyAddress],table_b.[PropertyAddress])
FROM NewPortfolio..['HousingData'] table_a
JOIN NewPortfolio..['HousingData'] table_b
    ON table_a.[ParcelID] = table_b.[ParcelID]
    AND table_a.[UniqueID] <> table_b.[UniqueID]
WHERE table_a.[PropertyAddress] IS NULL



--Then we check that we do not have more NULL values.


Select *
from NewPortfolio..['HousingData']
Where PropertyAddress is null



--Breaking out Property Address

--- seperating address into (address,city,state) columns



select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress)) as City
From NewPortfolio..['HousingData']

alter table NewPortfolio..['HousingData']
add PropertySplitAddress nvarchar(255)

update NewPortfolio..['HousingData']
set PropertySplitAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

alter table NewPortfolio..['HousingData']
add PropertyCity nvarchar(255)

update NewPortfolio..['HousingData']
set PropertyCity =  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress))

select * from NewPortfolio..['HousingData']




--- splitting owner's address




select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
from NewPortfolio..['HousingData']

alter table NewPortfolio..['HousingData']
add ownersplitedaddress nvarchar(255)

update NewPortfolio..['HousingData']
set ownersplitedaddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NewPortfolio..['HousingData']
add ownercity nvarchar(255)

update NewPortfolio..['HousingData']
set ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NewPortfolio..['HousingData']
add ownerstate nvarchar(255)

update NewPortfolio..['HousingData']
set ownerstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from NewPortfolio..['HousingData']




--- Converting 'Y' & 'N'to 'YES'& 'NO'



select SoldAsVacant , CASE when SoldAsVacant = 'Y' then 'Yes' 
							when SoldAsVacant = 'N' then 'No'
							else SoldAsVacant
							end 
from NewPortfolio..['HousingData']

update NewPortfolio..['HousingData']
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes' 
							when SoldAsVacant = 'N' then 'No'
							else SoldAsVacant
							end 

select Distinct(SoldAsVacant), COUNT(SoldAsVacant) 
from NewPortfolio..['HousingData']
group by SoldAsVacant




--- Removing Duplicates Data from the Table



with duplicatesCTE AS(
select * , ROW_NUMBER() Over (Partition By ParcelID,PropertyAddress,Saleprice,
SaleDate,LegalReference order by UniqueID) duplicates
from NewPortfolio..['HousingData']
)
delete  from duplicatesCTE
where duplicates > 1




--- confirming the deleted duplicates



with duplicatesCTE AS(
select * , ROW_NUMBER() Over (Partition By ParcelID,PropertyAddress,Saleprice,
SaleDate,LegalReference order by UniqueID) duplicates
from NewPortfolio..['HousingData']
)
select * from duplicatesCTE
where duplicates > 1




--- Deleting Unsual Columns



select * from NewPortfolio..['HousingData']

alter table NewPortfolio..[HousingData]
drop column PropertyAddress,OwnerAddress,TaxDistrict


--- cleaned data


select * from NewPortfolio..['HousingData']