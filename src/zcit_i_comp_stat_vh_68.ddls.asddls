@EndUserText.label: 'Complaint Status Dropdown'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCIT_I_COMP_STAT_VH_68 
  as select from I_Language 
{
      @UI.textArrangement: #TEXT_ONLY
  key cast('New' as abap.char(15)) as Status,
      cast('New' as abap.char(15)) as StatusText
}
union select from I_Language 
{
  key cast('In Progress' as abap.char(15)) as Status,
      cast('In Progress' as abap.char(15)) as StatusText
}
union select from I_Language 
{
  key cast('Resolved' as abap.char(15)) as Status,
      cast('Resolved' as abap.char(15)) as StatusText
}
