@EndUserText.label: 'Complaint Category Dropdown'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCIT_I_COMP_CAT_VH_68 
  as select from I_Language 
{
      @UI.textArrangement: #TEXT_ONLY
  key cast('Technical' as abap.char(20)) as Category,
      cast('Technical' as abap.char(20)) as CategoryText
}
union select from I_Language 
{
  key cast('Billing' as abap.char(20)) as Category,
      cast('Billing' as abap.char(20)) as CategoryText
}
union select from I_Language 
{
  key cast('Service' as abap.char(20)) as Category,
      cast('Service' as abap.char(20)) as CategoryText
}
