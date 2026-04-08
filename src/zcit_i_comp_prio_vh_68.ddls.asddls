@EndUserText.label: 'Complaint Priority Dropdown'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCIT_I_COMP_PRIO_VH_68 
  as select from I_Language 
{
      @UI.textArrangement: #TEXT_ONLY
  key cast('High' as abap.char(10)) as Priority,
      cast('High' as abap.char(10)) as PriorityText
}
union select from I_Language 
{
  key cast('Medium' as abap.char(10)) as Priority,
      cast('Medium' as abap.char(10)) as PriorityText
}
union select from I_Language 
{
  key cast('Low' as abap.char(10)) as Priority,
      cast('Low' as abap.char(10)) as PriorityText
}
