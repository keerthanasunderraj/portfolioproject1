--Cleaning Data in Sql
select * from portfolioprojects.dbo.NashvilleHousing$

      --Standardize Date Format

select SaleDate,CONVERT(Date,SaleDate)  from portfolioprojects.dbo.NashvilleHousing$
update portfolioprojects.dbo.NashvilleHousing$ set SaleDate=CONVERT(Date,SaleDate)
Alter table portfolioprojects.dbo.NashvilleHousing$ add SaleDateConverted Date;
update portfolioprojects.dbo.NashvilleHousing$ set SaleDateConverted=CONVERT(Date,SaleDate)
select SaleDateConverted,CONVERT(Date,SaleDate)  from portfolioprojects.dbo.NashvilleHousing$

     --Populate Property Address Data
select PropertyAddress from portfolioprojects.dbo.NashvilleHousing$


select * from portfolioprojects.dbo.NashvilleHousing$ order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioprojects.dbo.NashvilleHousing$ a
join
portfolioprojects.dbo.NashvilleHousing$ b
on a.ParcelID=b.ParcelID 
AND
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress) 

from portfolioprojects.dbo.NashvilleHousing$ a
join
portfolioprojects.dbo.NashvilleHousing$ b
on a.ParcelID=b.ParcelID 
AND
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into individual columns(Address,City,State)

 select PropertyAddress from portfolioprojects.dbo.NashvilleHousing$

 select 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))as Address
 from portfolioprojects.dbo.NashvilleHousing$ 
 

 Alter table  portfolioprojects.dbo.NashvilleHousing$ 
 Add PropertySplitAddress nvarchar(255);


 update  portfolioprojects.dbo.NashvilleHousing$ 
 set PropertySplitAddress  =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

 Alter Table portfolioprojects.dbo.NashvilleHousing$ 
 Add PropertySplitCity nvarchar(255);
 
 update portfolioprojects.dbo.NashvilleHousing$
 set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

 select * from portfolioprojects.dbo.NashvilleHousing$ 


 select OwnerAddress from portfolioprojects.dbo.NashvilleHousing$ 
 select parsename(OwnerAddress,1)         from portfolioprojects.dbo.NashvilleHousing$ 
 
 select PARSENAME(Replace(OwnerAddress,',','.'),3)  ,
  PARSENAME(Replace(OwnerAddress,',','.'),2),
 PARSENAME(Replace(OwnerAddress,',','.'),1)from portfolioprojects.dbo.NashvilleHousing$  


 Alter Table portfolioprojects.dbo.NashvilleHousing$ 
 Add OwnerSplitAddress nvarchar(255);
 
 update portfolioprojects.dbo.NashvilleHousing$
 set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3) 

Alter Table portfolioprojects.dbo.NashvilleHousing$ 
 Add OwnerSplitCity nvarchar(255);
 
 update portfolioprojects.dbo.NashvilleHousing$
 set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)



 Alter Table portfolioprojects.dbo.NashvilleHousing$ 
 Add OwnerSplitState nvarchar(255);
 
 update portfolioprojects.dbo.NashvilleHousing$
 set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)
 

 select * from portfolioprojects.dbo.NashvilleHousing$ 

 --Change Yes and NO to Y and N in Sold as vacant field

 select Distinct(SoldAsVacant),count(SoldAsVacant) from portfolioprojects.dbo.NashvilleHousing$ 
 group by SoldAsVacant
 order by 2

  select SoldAsVacant
  ,case when SoldAsVacant='Y' then 'Yes'
        when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end
  from portfolioprojects.dbo.NashvilleHousing$ 

  update portfolioprojects.dbo.NashvilleHousing$ 
  set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
        when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end

		--Remove Duplicates
	select *	from portfolioprojects.dbo.NashvilleHousing$ 

	WITH RowNumberCTE  as(
	
		select * ,
		Row_number() over(
		partition by ParcelId,
		              PropertyAddress,
					  SaleDate,
					  LegalReference
					  order by UniqueId
					  )row_num
		            
		from portfolioprojects.dbo.NashvilleHousing$ 
)
select * from  RowNumberCTE  where row_num>1
order by PropertyAddress

--Delete Unused Columns
 select * from portfolioprojects.dbo.NashvilleHousing$
 alter table portfolioprojects.dbo.NashvilleHousing$
 drop column PropertyAddress,OwnerAddress,TaxDistrict
 alter table portfolioprojects.dbo.NashvilleHousing$
 drop column SaleDate